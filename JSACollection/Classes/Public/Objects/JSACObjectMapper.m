//
//  JSACObjectMapper.m
//  JSACollection
//
//  Created by Nelson LeDuc on 2/19/15.
//  Copyright (c) 2015 Nelson LeDuc. All rights reserved.
//

#import "JSACObjectMapper.h"
#import "JSACKeyGenerator.h"
#import "NSObject+ListOfProperties.h"
#import "JSACCollectionSerializer.h"

static NSString * const kJSACollectionModelArrayPrefix = @"MODEL_ARRAY_%@";

@interface NSObject (JSACollectionCategory)

+ (NSDictionary *)JSONKeyMapping;

@end


@interface JSACObjectMapper ()

@property (nonatomic, assign) BOOL usingCustomDictionary;
@property (nonatomic, strong) NSDictionary *keyDictionary;
@property (nonatomic, strong) Class objectClass;
@property (nonatomic, strong) NSMutableDictionary *virtualDictionary;
@property (nonatomic, strong) NSMutableDictionary *subMapperDictionary;

@end

@implementation JSACObjectMapper

+ (instancetype)objectMapperForClass:(Class)clazz
{
    return [[self alloc] initWithClass:clazz];
}

- (instancetype)initWithClass:(Class)clazz
{
    self = [super init];
    if (self)
    {
        _objectClass = clazz;
        _allowNonStandardTypes = NO;
        _usingCustomDictionary = NO;
    }
    
    return self;
}

- (NSDictionary *)keyDictionary
{
    if (!_keyDictionary)
    {
        NSDictionary *keyDict;
        
        if ([self.objectClass respondsToSelector:@selector(JSONKeyMapping)])
        {
            keyDict = [self.objectClass JSONKeyMapping];
            NSAssert(keyDict, @"Custom implementation of JSONKeyMapping must not return a nil dictionary.");
        }
        else if (self.allowNonStandardTypes)
        {
            keyDict = [JSACKeyGenerator keyListFromClass:self.objectClass];
        }
        else
        {
            keyDict = [JSACKeyGenerator standardKeyListFromClass:self.objectClass];
        }
        
        if (!keyDict || ![keyDict count])
        {
            keyDict = [NSDictionary dictionary];
        }
        
        NSMutableDictionary *virtualDict = [[JSACKeyGenerator generatedKeyListFromArray:[self.virtualDictionary allKeys]] mutableCopy];
        [virtualDict addEntriesFromDictionary:keyDict];
        keyDict = [virtualDict copy];
        
        _keyDictionary = keyDict;
    }
    
    return _keyDictionary;
}

- (void)setAllowNonStandardTypes:(BOOL)allowNonStandardTypes
{
    if (_allowNonStandardTypes == allowNonStandardTypes)
        return;
    
    _allowNonStandardTypes = allowNonStandardTypes;
    
    if (!self.usingCustomDictionary)
        self.keyDictionary = nil;
}

- (NSMutableDictionary *)virtualDictionary
{
    if (!_virtualDictionary)
        _virtualDictionary = [NSMutableDictionary dictionary];
    
    return _virtualDictionary;
}

- (NSMutableDictionary *)subMapperDictionary
{
    if (!_subMapperDictionary)
        _subMapperDictionary = [NSMutableDictionary dictionary];
    
    return _subMapperDictionary;
}

- (void)addSetterForPropertyWithName:(NSString *)name withBlock:(JSACObjectMapperPropertySetterBlock)block
{
    if (!block || !name)
        return;
    
    [self.virtualDictionary setObject:block forKey:name];
}

- (void)addSubObjectMapper:(JSACObjectMapper *)mapper forPropertyName:(NSString *)name
{
    if (!mapper || !name)
        return;
    
    [self.subMapperDictionary setObject:mapper forKey:name];
}

- (void)setCustomKeyDictionary:(NSDictionary *)keyDictionary
{
    self.keyDictionary = keyDictionary;
    self.usingCustomDictionary = !keyDictionary ? NO : YES;
}

#pragma mark - JSACSerializableClassFactory

- (NSArray *)listOfKeys
{
    return [self.keyDictionary allKeys];
}

- (id)objectForDictionary:(NSDictionary *)dictionary forCollectionSerializer:(JSACCollectionSerializer *)serializer
{
    NSDictionary *userInfo;
    if (self.dateFormatter)
    {
        userInfo = @{ JSACUserInfoDateFormatterKey : self.dateFormatter };
    }
    
    NSDictionary *normalizedDict = dictionary;
    if ([normalizedDict isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
        [normalizedDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [normalDict setObject:obj forKey:[key lowercaseString]];
        }];
        normalizedDict = normalDict;
    }
    
    id modelObject = [[self.objectClass alloc] init];
    
    if (self.setterBlock)
    {
        modelObject = self.setterBlock(dictionary, modelObject);
    }
    else
    {
        for (NSString *key in [self listOfKeys])
        {
            id value = [normalizedDict valueForKey:[key lowercaseString]];
            if (value)
            {
                NSString *objectKey = [self.keyDictionary valueForKey:key];
                if ([self.virtualDictionary objectForKey:objectKey])
                {
                    JSACObjectMapperPropertySetterBlock propBlock = self.virtualDictionary[objectKey];
                    propBlock(value, modelObject);
                }
                else if (![self setupModelArrayIfNecessaryWithValue:value forKey:objectKey onObject:modelObject withSerializer:serializer])
                {
                    BOOL standard = [modelObject setStandardValue:value forKey:objectKey userInfo:userInfo];
                    if (!standard && self.allowNonStandardTypes)
                        [self setNonStandardValue:value onObject:modelObject forKey:[self.keyDictionary valueForKey:key] withSerializer:serializer];
                }
            }
        }
    }
    
    return modelObject;
}

#pragma mark - Private

- (BOOL)setupModelArrayIfNecessaryWithValue:(id)value forKey:(NSString *)key onObject:(id)object withSerializer:(JSACCollectionSerializer *)serializer
{
    NSString *modelArrayString = [NSString stringWithFormat:kJSACollectionModelArrayPrefix, key];
    BOOL exists = NO;
    NSArray *keyList = [object listOfProperties];
    for (NSString *k in keyList)
        if ([k isEqualToString:modelArrayString])
            exists = YES;
    
    if (!exists)
        return NO;
    
    Class clazz = [object classForPropertyKey:modelArrayString];
    JSACObjectMapper *subMapper = self.subMapperDictionary[key];
    if (!subMapper)
        subMapper = [JSACObjectMapper objectMapperForClass:clazz];
    
    NSArray *array = [serializer generateModelObjectsWithSerializableClassFactory:subMapper fromContainer:value];
    [object setStandardValue:array forKey:key];
    
    return YES;
}


- (BOOL)setNonStandardValue:(id)value onObject:(id)object forKey:(NSString *)key withSerializer:(JSACCollectionSerializer *)serializer
{
    if (object == nil || key == nil || object == [NSNull null])
        return NO;
    
    Class clazz = [object classForPropertyKey:key];
    JSACObjectMapper *subMapper = self.subMapperDictionary[key];
    if (!subMapper)
    {
        subMapper = [JSACObjectMapper objectMapperForClass:clazz];
        subMapper.allowNonStandardTypes = self.allowNonStandardTypes;
    }
    
    NSArray *array = [serializer generateModelObjectsWithSerializableClassFactory:subMapper fromContainer:value];
    if (array)
        if (key)
            if ([array firstObject])
            {
                [object setValue:[array firstObject] forKey:key];
                return YES;
            }
    return NO;
}

@end
