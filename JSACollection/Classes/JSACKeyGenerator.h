//
//  JSACKeyGenerator.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 12/17/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSACKeyGenerator : NSObject

+ (NSDictionary *)keyListFromClass:(Class)class;
+ (NSDictionary *)standardKeyListFromClass:(Class)class;
+ (NSDictionary *)nonStandardKeyListFromClass:(Class)class;

@end
