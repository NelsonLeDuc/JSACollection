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
    return [self containerWithModelObjectProperties:properties fromCollection:dataCollection withPreviousLayer:dataCollection];
}

+ (id)containerWithModelObjectProperties:(NSArray*)propertyList fromCollection:(JSACCollection*)collection withPreviousLayer:(id)layer
{
    id obj;
    for (id key in collection)
    {
        if (![propertyList containsString:key])
        {
            if (!obj)
                obj = [self containerWithModelObjectProperties:propertyList fromCollection:[collection subCollectionFromKey:key] withPreviousLayer:collection];
        }
        else
        {
            if ([layer isEqualToCollection:collection])
            {
                return [JSACCollectionFactory collectionWithObject:@[ [layer dictionary] ]];
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

@end
