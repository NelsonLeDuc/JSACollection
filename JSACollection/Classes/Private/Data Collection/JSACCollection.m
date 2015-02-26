//
//  JSADataCollection.m
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACCollection.h"

@implementation JSACCollection

- (JSACCollection*)subCollectionFromKey:(id)key
{
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return 0;
}

- (id)valueForKey:(NSString *)key
{
    return nil;
}

- (NSInteger)count
{
    return 0;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    
    return [self isEqualToCollection:object];
}

- (BOOL)isEqualToCollection:(JSACCollection *)collection
{
    return NO;
}

@end
