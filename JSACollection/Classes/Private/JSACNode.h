//
//  JSACNode.h
//  JSACollection
//
//  Created by Nelson LeDuc on 12/26/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSACNodeList;

@interface JSACNode : NSObject

@property (nonatomic, strong) id actualStorage;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *subNodes;

- (instancetype)initWithContainer:(id)container;
- (JSACNodeList *)nodesMatchingKeys:(NSArray *)keys;

+ (instancetype)nodeWithContainer:(id)container;

@end
