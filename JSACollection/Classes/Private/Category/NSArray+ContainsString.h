//
//  NSArray+ContainsString.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/3/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ContainsString)

- (BOOL)jsac_containsString:(NSString*)string;
- (BOOL)jsac_containsString:(NSString *)string ignoreCase:(BOOL)ignoreCase;

@end
