//
//  JSACNodeList.h
//  JSACollection
//
//  Created by Nelson LeDuc on 1/6/16.
//  Copyright © 2016 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSACNodeList : NSObject

@property (nonatomic, strong, readonly) NSArray *nodes;

- (instancetype)initWithNodes:(NSArray *)nodes;
+ (instancetype)nodeListWithNodes:(NSArray *)nodes;

@end
