//
//  JSACLayerFinder.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 1/31/14.
//  Copyright (c) 2014 Jump Space Apps. All rights reserved.
//

#import "JSACLayerFinder.h"
#import "JSACCollection.h"
#import "JSACDictionaryCollection.h"
#import "JSACCollectionFactory.h"
#import "NSArray+ContainsString.h"

@implementation JSACLayerFinder

+ (id)modelContainerWithProperties:(NSArray *)properties fromContainer:(id)container
{
    JSACCollection *dataCollection = [JSACCollectionFactory collectionWithObject:container];
    return [self containerWithModelObjectProperties:properties fromCollection:dataCollection withPreviousLayer:dataCollection fromKey:nil];
}

+ (id)containerWithModelObjectProperties:(NSArray*)propertyList fromCollection:(JSACCollection*)collection withPreviousLayer:(id)layer fromKey:(id)fromKey
{
    id obj;
    for (id key in collection)
    {
        if (![propertyList jsac_containsString:key])
        {
            if (!obj)
                obj = [self containerWithModelObjectProperties:propertyList fromCollection:[collection subCollectionFromKey:key] withPreviousLayer:collection fromKey:key];
        }
        else
        {
            if ([layer isEqualToCollection:collection])
            {
                return [JSACCollectionFactory collectionWithObject:@[ [layer dictionary] ]];
            }
            else if ([layer parentCollection] &&
                     [layer isKindOfClass:[JSACDictionaryCollection class]] &&
                     ![[layer parentCollection] isKindOfClass:[JSACDictionaryCollection class]])
            {
                layer = [self flattenArrayLayer:[layer parentCollection] withKey:fromKey];
            }
            
            return layer;
        }
    }
    if (obj)
    {
        return obj;
    }
    
    return nil;
}

+ (id)flattenArrayLayer:(id)layer withKey:(NSString *)key
{
    NSMutableArray *array = [NSMutableArray array];
    for (id subObj in layer)
    {
        id obj = [[JSACCollectionFactory collectionWithObject:subObj] subCollectionFromKey:key];
        [array addObject:obj];
    }
    
    return [JSACCollectionFactory collectionWithObject:[array copy]];
}

@end
