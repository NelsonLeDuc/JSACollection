//
//  NSArray+ContainsString.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/3/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import "NSArray+ContainsString.h"

@implementation NSArray (ContainsString)

- (BOOL)containsString:(NSString *)string
{
    return [self containsString:string ignoreCase:YES];
}

- (BOOL)containsString:(NSString *)string ignoreCase:(BOOL)ignoreCase
{
    if (![string respondsToSelector:@selector(lowercaseString)])
        return NO;
    for (NSString *s in self) {
        if ([(ignoreCase ? s : [s lowercaseString]) isEqualToString:(ignoreCase ? string : [string lowercaseString])]) {
            return YES;
        }
    }
    
    return NO;
}

@end
