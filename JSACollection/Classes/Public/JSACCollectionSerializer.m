//
//  JSAJSONSerializer.m
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACCollectionSerializer.h"
#import "JSACSerializableClassFactory.h"
#import "JSACLayerFinder.h"
#import "JSACObjectMapper.h"

@interface NSObject (JSACollectionCategory)

+ (NSDictionary *)JSONKeyMapping;

@end

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
    JSACObjectMapper *objectMapper = [JSACObjectMapper objectMapperForClass:class];
    objectMapper.allowNonStandardTypes = self.allowNonStandardTypes;
    
    return [self generateModelObjectsWithSerializableClassFactory:objectMapper fromContainer:container];
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
        modelObject = [serializableClassFactory objectForDictionary:model forCollectionSerializer:self];
        [modelObjectArray addObject:modelObject];
    }
    
    return modelObjectArray;
}

@end
