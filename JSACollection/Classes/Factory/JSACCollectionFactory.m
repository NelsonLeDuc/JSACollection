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
    if ([collection isKindOfClass:[JSACArrayCollection class]])
        return collection;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (id obj in collection)
    {
        JSACCollection *coll = [collection subCollectionFromKey:obj];
        if (coll)
            [mutableArray addObject:coll];
    }

    if (ABS([mutableArray count] - [collection count]) > 5)
        mutableArray = [NSMutableArray arrayWithObject:collection];
    return [self collectionWithObject:mutableArray];
}

@end
