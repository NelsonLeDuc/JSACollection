//
//  JSADataCollectionFactory.m
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACCollectionFactory.h"
#import "JSACCollection.h"
#import "JSACArrayCollection.h"
#import "JSACDictionaryCollection.h"

@implementation JSACCollectionFactory

+ (BOOL)usableTypeOfCollection:(id)collection
{
    return ([self collectionWithObject:collection] != nil);
}

+ (JSACCollection *)collectionWithObject:(id)collection
{
    if ([collection isKindOfClass:[NSArray class]])
    {
        return [[JSACArrayCollection alloc] initWithArray:collection];
    }
    else if ([collection isKindOfClass:[NSDictionary class]])
    {
        return [[JSACDictionaryCollection alloc] initWithDictionary:collection];
    }
    else
    {
        return nil;
    }
}

+ (JSACCollection *)generateUsableCollectionFromCollection:(JSACCollection *)collection
{
    JSACCollection *coll = collection;
    if ([collection isKindOfClass:[JSACDictionaryCollection class]])
    {
        NSArray *arr = [[((JSACDictionaryCollection *)collection).dictionary allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject isKindOfClass:[NSDictionary class]];
        }]];
        
        coll = [self collectionWithObject:arr];
    }
    
    return coll;
}

@end