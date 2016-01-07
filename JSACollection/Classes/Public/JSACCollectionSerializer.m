//
//  JSAJSONSerializer.m
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACCollectionSerializer.h"
#import "JSACSerializableClassFactory.h"
#import "JSACObjectMapper.h"

#import "JSACNode.h"
#import "JSACNodeList.h"

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
    objectMapper.dateFormatter = self.dateFormatter;
    
    return [self generateModelObjectsWithSerializableClassFactory:objectMapper fromContainer:container];
}

- (NSArray *)generateModelObjectsWithSerializableClassFactory:(id<JSACSerializableClassFactory>)serializableClassFactory fromContainer:(id)container
{
    NSArray *keyList = [serializableClassFactory listOfKeys];
    JSACNodeList *nodeList = [[JSACNode nodeWithContainer:container] nodesMatchingKeys:keyList];
    NSMutableArray *modelObjectArray = [NSMutableArray array];
    
    for (JSACNode *node in nodeList.nodes)
    {
        id modelObject = [serializableClassFactory objectForDictionary:[node actualStorage] forCollectionSerializer:self];
   
        if (modelObject) {
            [modelObjectArray addObject:modelObject];
        }
    }
    
    return modelObjectArray;
}

@end
