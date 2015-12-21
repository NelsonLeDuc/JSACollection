//
//  JSACKeyGenerator.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 12/17/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JSACKeyGeneratorKeyType) {
    JSACKeyGeneratorKeyTypeAll,
    JSACKeyGeneratorKeyTypeStandard,
    JSACKeyGeneratorKeyTypeNonStandard
};

@interface JSACKeyGenerator : NSObject

+ (NSDictionary *)keyListFromClass:(Class)clazz ofType:(JSACKeyGeneratorKeyType)type;
+ (NSDictionary *)generatedKeyListFromArray:(NSArray *)array;

@end
