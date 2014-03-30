//
//  JSADataDictionaryCollection.m
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "JSACDictionaryCollection.h"
#import "JSACCollectionFactory.h"

@interface JSACDictionaryCollection ()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation JSACDictionaryCollection

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _dictionary = dictionary;
    }
    return self;
}

#pragma mark - Public

- (JSACCollection *)subCollectionFromKey:(id)key
{
    id obj = [JSACCollectionFactory collectionWithObject:[self.dictionary valueForKey:key]];
    return obj;
}

- (NSInteger)count
{
    return [[self.dictionary allKeys] count];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_dictionary countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@", [super description], [_dictionary description]];
}

- (id)valueForKey:(NSString *)key
{
    return [_dictionary valueForKey:key];
}

@end
