//
//  JSADataArrayCollection.m
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACArrayCollection.h"
#import "JSACCollectionFactory.h"

@interface JSACArrayCollection ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation JSACArrayCollection

#pragma mark - Init

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        _array = array;
    }
    return self;
}

#pragma mark - Public

- (JSACCollection*)subCollectionFromKey:(id)key
{
    return [JSACCollectionFactory collectionWithObject:key];
}

- (NSInteger)count
{
    return [self.array count];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

@end
