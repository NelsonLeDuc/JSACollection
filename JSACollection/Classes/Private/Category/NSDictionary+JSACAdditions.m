//
//  NSDictionary+JSACAdditions.m
//  JSACollection
//
//  Created by Nelson LeDuc on 12/21/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import "NSDictionary+JSACAdditions.h"

@implementation NSDictionary (JSACAdditions)

- (instancetype)jsac_lowercaseKeyDictionary {
    if (![self.allKeys.firstObject isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"This is not a dictionary with string keys.");
        return self;
    }
    
    NSMutableDictionary *lowercaseDict = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [lowercaseDict setObject:obj forKey:[key lowercaseString]];
    }];
    
    return lowercaseDict;
}

@end
