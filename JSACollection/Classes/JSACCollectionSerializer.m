//
//  JSAJSONSerializer.m
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACCollectionSerializer.h"
#import "JSACCollectionFactory.h"
#import "NSObject+ListOfProperties.h"
#import "JSACSerializableClassFactory.h"
#import "JSACKeyGenerator.h"
#import "JSACLayerFinder.h"

@implementation JSACCollectionSerializer

#pragma mark - Class Methods

+ (instancetype)sharedInstance
{
    static JSACCollectionSerializer *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JSACCollectionSerializer alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Public

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _allowNonStandardTypes = NO;
    }
    return self;
}

- (NSArray *)generateModelObjectsWithSerializableClass:(Class)class fromContainer:(id)container
{
    NSDictionary *keyDict = [JSACKeyGenerator standardKeyListFromClass:class];
    if (self.allowNonStandardTypes)
        keyDict = [JSACKeyGenerator keyListFromClass:class];
    
    return [self generateModelObjectsWithSerializableClass:class fromContainer:container withPropertyDictionary:keyDict];
}

- (NSArray *)generateModelObjectsWithSerializableClass:(Class)class fromContainer:(id)container withPropertyDictionary:(NSDictionary *)propertyDictionary
{
    if (![JSACCollectionFactory usableTypeOfCollection:container])
        return [NSArray array];
    
    NSArray *keyList = [propertyDictionary allKeys];
    
    id modelContainer = [JSACLayerFinder modelContainerWithProperties:keyList fromContainer:container];
    id modelObject;
    
    NSMutableArray *modelObjectArray = [[NSMutableArray alloc] init];
    
    modelContainer = [JSACCollectionFactory generateUsableCollectionFromCollection:modelContainer];
    
    for (id model in modelContainer)
    {
        modelObject = [[class alloc] init];
        for (NSString *key in [propertyDictionary allKeys])
        {
            id value = [model valueForKey:key];
            if (value)
            {
                NSString *objectKey = [propertyDictionary valueForKey:key];
                if (![self setupModelArrayIfNecessaryWithValue:value forKey:objectKey onObject:modelObject])
                {
                    BOOL standard = [modelObject setStandardValue:value forKey:objectKey];
                    if (!standard && self.allowNonStandardTypes)
                        [self setNonStandardValue:value onObject:modelObject forKey:[propertyDictionary valueForKey:key]];
                }
            }
            
        }
        [modelObjectArray addObject:modelObject];
    }
    
    return [NSArray arrayWithArray:modelObjectArray];
}

- (NSArray *)generateModelObjectsWithSerializableClassFactory:(id<JSACSerializableClassFactory>)serializableClassFactory fromContainer:(id)container
{
    NSArray *keyList;
    keyList = [serializableClassFactory listOfKeys];
    
    id modelContainer = [JSACLayerFinder modelContainerWithProperties:keyList fromContainer:container];
    id modelObject;
    
    NSMutableArray *modelObjectArray = [[NSMutableArray alloc] init];
    
    for (id model in modelContainer)
    {
        modelObject = [serializableClassFactory objectForDictionary:model];
        [modelObjectArray addObject:modelObject];
    }
    
    return modelObjectArray;
}

#pragma mark - Private

- (BOOL)setupModelArrayIfNecessaryWithValue:(id)value forKey:(NSString *)key onObject:(id)object
{
    NSString *modelArrayString = [NSString stringWithFormat:@"MODEL_ARRAY_%@", key];
    BOOL exists = NO;
    NSArray *keyList = [object listOfProperties];
    for (NSString *k in keyList)
        if ([k isEqualToString:modelArrayString])
            exists = YES;
    
    if (!exists)
        return NO;
    
    Class clazz = [object classForPropertyKey:modelArrayString];
    NSArray *array = [self generateModelObjectsWithSerializableClass:clazz fromContainer:value];
    [object setStandardValue:array forKey:key];
    
    return YES;
}


- (BOOL)setNonStandardValue:(id)value onObject:(id)object forKey:(NSString *)key
{
    Class clazz = [object classForPropertyKey:key];
    NSArray *array = [self generateModelObjectsWithSerializableClass:clazz fromContainer:value];
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
