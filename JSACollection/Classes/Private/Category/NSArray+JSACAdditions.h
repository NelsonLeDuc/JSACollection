//
//  NSArray+JSACAdditions.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/3/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JSACAdditions)

- (BOOL)jsac_containsString:(NSString*)string;
- (BOOL)jsac_containsString:(NSString *)string ignoreCase:(BOOL)ignoreCase;
- (NSArray *)jsac_flattenedArray;

@end
