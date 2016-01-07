//
//  NSArray+JSACAdditions.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/3/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import "NSArray+JSACAdditions.h"

@implementation NSArray (JSACAdditions)

- (BOOL)jsac_containsString:(NSString *)string
{
    return [self jsac_containsString:string ignoreCase:YES];
}

- (BOOL)jsac_containsString:(NSString *)string ignoreCase:(BOOL)ignoreCase
{
    if (![string respondsToSelector:@selector(lowercaseString)])
    {
        return NO;
    }
    
    string = (ignoreCase ? [string lowercaseString] : string);
    for (NSString *s in self)
    {
        NSString *strToCheck = (ignoreCase ? [s lowercaseString] : s);
        if ([string isEqualToString:strToCheck])
        {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)jsac_flattenedArray
{
    NSMutableArray *flattened = [NSMutableArray array];
    for (id obj in self)
    {
        if ([obj isKindOfClass:[NSArray class]]) {
            [flattened addObjectsFromArray:[(NSArray *)obj jsac_flattenedArray]];
        } else {
            [flattened addObject:obj];
        }
    }
    
    return [flattened copy];
}

@end
