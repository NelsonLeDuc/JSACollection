//
//  JSACObjectMapper.m
//  JSACollection
//
//  Created by Nelson LeDuc on 2/19/15.
//  Copyright (c) 2015 Nelson LeDuc. All rights reserved.
//

#import "JSACObjectMapper.h"
#import "JSACKeyGenerator.h"
#import "JSACCollectionSerializer.h"
#import "JSACUtility.h"

#import "NSArray+ContainsString.h"
#import "NSObject+ListOfProperties.h"
#import "NSDictionary+JSACAdditions.h"

static NSString * const kJSACollectionModelArrayPrefix = @"MODEL_ARRAY_%@";
static NSString * const kJSACollectionModelParentPrefix = @"MODEL_PARENT_%@";

@interface NSObject (JSACollectionCategory)

+ (NSDictionary *)JSONKeyMapping;

@end


@interface JSACObjectMapper ()

@property (nonatomic, assign) BOOL usingCustomDictionary;
@property (nonatomic, strong) NSDictionary *keyDictionary;
@property (nonatomic, strong) Class objectClass;
@property (nonatomic, strong) NSMutableDictionary<NSString *, JSACObjectMapperPropertySetterBlock> *virtualDictionary;
@property (nonatomic, strong) NSMutableDictionary *subMapperDictionary;
@property (nonatomic, strong) id parentObject;

@end

@implementation JSACObjectMapper

+ (instancetype)objectMapperForClass:(Class)clazz {
    return [[self alloc] initWithClass:clazz];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init {
    NSAssert(NO, @"-init should not be called, call -initWithClass: instead");
    return nil;
}
#pragma clang diagnostic pop

- (instancetype)initWithClass:(Class)clazz {
    self = [super init];
    if (self) {
        _objectClass = clazz;
        _allowNonStandardTypes = NO;
        _usingCustomDictionary = NO;
    }
    
    return self;
}

#pragma mark - Getters / Setters

- (NSDictionary *)keyDictionary {
    if (!_keyDictionary) {
        NSDictionary *keyDict;
        if ([self.objectClass respondsToSelector:@selector(JSONKeyMapping)]) {
            keyDict = [self.objectClass JSONKeyMapping];
            NSAssert(keyDict, @"Custom implementation of JSONKeyMapping must not return a nil dictionary.");
        } else {
            JSACKeyGeneratorKeyType type = self.allowNonStandardTypes ? JSACKeyGeneratorKeyTypeAll : JSACKeyGeneratorKeyTypeStandard;
            keyDict = [JSACKeyGenerator keyListFromClass:self.objectClass ofType:type];
        }
        
        keyDict = keyDict ?: @{};
        
        NSMutableDictionary *virtualDict = [[JSACKeyGenerator generatedKeyListFromArray:self.virtualDictionary.allKeys] mutableCopy];
        [virtualDict addEntriesFromDictionary:keyDict];
        
        _keyDictionary = [virtualDict copy];
    }
    
    return _keyDictionary;
}

- (void)setAllowNonStandardTypes:(BOOL)allowNonStandardTypes {
    if (_allowNonStandardTypes == allowNonStandardTypes) {
        return;
    }
    
    _allowNonStandardTypes = allowNonStandardTypes;
    
    if (!self.usingCustomDictionary) {
        self.keyDictionary = nil;
    }
}

- (NSMutableDictionary<NSString *, JSACObjectMapperPropertySetterBlock> *)virtualDictionary {
    if (!_virtualDictionary) {
        _virtualDictionary = [NSMutableDictionary dictionary];
    }
    
    return _virtualDictionary;
}

- (NSMutableDictionary *)subMapperDictionary
{
    if (!_subMapperDictionary) {
        _subMapperDictionary = [NSMutableDictionary dictionary];
    }
    
    return _subMapperDictionary;
}

#pragma mark - Public Methods

- (void)addSetterForPropertyWithName:(NSString *)name withBlock:(JSACObjectMapperPropertySetterBlock)block {
    if (!block || !name) {
        return;
    }
    
    [self.virtualDictionary setObject:block forKey:name];
}

- (void)addSubObjectMapper:(JSACObjectMapper *)mapper forPropertyName:(NSString *)name {
    if (!mapper || !name)
        return;
    
    [self.subMapperDictionary setObject:mapper forKey:name];
}

- (void)setCustomKeyDictionary:(NSDictionary *)keyDictionary {
    self.keyDictionary = keyDictionary;
    self.usingCustomDictionary = !keyDictionary ? NO : YES;
}

#pragma mark - JSACSerializableClassFactory

- (NSArray *)listOfKeys {
    return [self.keyDictionary allKeys];
}

- (nullable id)objectForDictionary:(nonnull id<KeyValueAccessible>)dictionary forCollectionSerializer:(nonnull JSACCollectionSerializer *)serializer {
    NSDictionary *userInfo;
    if (self.dateFormatter) {
        userInfo = @{ JSACUserInfoDateFormatterKey : self.dateFormatter };
    }
    
    id<KeyValueAccessible> normalizedDict = dictionary;
    if ([normalizedDict isKindOfClass:[NSDictionary class]]) {
        normalizedDict = (id<KeyValueAccessible>)[(NSDictionary *)normalizedDict jsac_lowercaseKeyDictionary];
    }
    
    id modelObject = [[self.objectClass alloc] init];
    NSString *parentPropName = parentPropertyName(self.objectClass);
    
    if (self.setterBlock) {
        modelObject = self.setterBlock(dictionary, modelObject);
    } else {
        
        for (NSString *key in [self listOfKeys]) {
            NSString *objectKey = [self.keyDictionary valueForKey:key];
            id value = [normalizedDict valueForKey:[key lowercaseString]];
            if (!value) {
                if ([key isEqualToString:parentPropName] && self.parentObject) {
                    [modelObject setValue:self.parentObject forKey:objectKey];
                } else if ([[modelObject listOfProperties] jsac_containsString:[NSString stringWithFormat:kJSACollectionModelParentPrefix, key]]
                           && self.parentObject) {
                    [modelObject setValue:objectKey forKey:self.parentObject];
                }
                
                continue;
            }
            
            if ([self.virtualDictionary objectForKey:objectKey]) {
                self.virtualDictionary[objectKey](value, modelObject);
            } else if (![self setupModelArrayIfNecessaryWithValue:value forKey:objectKey onObject:modelObject withSerializer:serializer]) {
                BOOL standard = [modelObject setStandardValue:value forKey:objectKey userInfo:userInfo];
                if (!standard && self.allowNonStandardTypes) {
                    [self setNonStandardValue:value onObject:modelObject forKey:objectKey withSerializer:serializer];
                }
            }
        }
    }
    
    return modelObject;
}

#pragma mark - Private

- (BOOL)setupModelArrayIfNecessaryWithValue:(id)value forKey:(NSString *)key onObject:(id)object withSerializer:(JSACCollectionSerializer *)serializer {
    NSDictionary *arrayTypeMap = mappedArrayClassTypes(self.objectClass);
    Class clazz;
    
    if (arrayTypeMap) {
        NSString *arrayType = arrayTypeMap[key];
        if (!arrayType) {
            return NO;
        }
        
        clazz = NSClassFromString(arrayType);
    } else {
        NSString *modelArrayString = [NSString stringWithFormat:kJSACollectionModelArrayPrefix, key];
        if (![[object listOfProperties] jsac_containsString:modelArrayString]) {
            return NO;
        }
        
        clazz = [object classForPropertyKey:modelArrayString];
    }
    
    if (!clazz) {
        return NO;
    }
    
    JSACObjectMapper *subMapper = self.subMapperDictionary[key] ?: [JSACObjectMapper objectMapperForClass:clazz];
    NSArray *array = [serializer generateModelObjectsWithSerializableClassFactory:subMapper fromContainer:value];
    [object setStandardValue:array forKey:key];
    
    return YES;
}


- (BOOL)setNonStandardValue:(id)value onObject:(id)object forKey:(NSString *)key withSerializer:(JSACCollectionSerializer *)serializer
{
    if (object == nil || object == [NSNull null] || key == nil) {
        return NO;
    }
    
    Class clazz = [object classForPropertyKey:key];
    JSACObjectMapper *subMapper = self.subMapperDictionary[key];
    if (!subMapper) {
        subMapper = [JSACObjectMapper objectMapperForClass:clazz];
        subMapper.allowNonStandardTypes = self.allowNonStandardTypes;
    }
    subMapper.parentObject = object;
    
    NSArray *array = [serializer generateModelObjectsWithSerializableClassFactory:subMapper fromContainer:value];
    if ([array count] && key) {
        [object setValue:[array firstObject] forKey:key];
        return YES;
    }
    
    return NO;
}

@end
