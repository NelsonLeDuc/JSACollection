//
//  JSACNode.m
//  JSACollection
//
//  Created by Nelson LeDuc on 12/26/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import "JSACNode.h"
#import "JSACNodeList.h"
#import "NSArray+JSACAdditions.h"

@implementation JSACNode

#pragma mark - Public Methods
- (instancetype)initWithContainer:(id)container {
    self = [super init];
    if (self) {
        
        NSArray *values;
        if ([container isKindOfClass:[NSArray class]]) {
            values = container;
        } else if ([container isKindOfClass:[NSDictionary class]]) {
            _keys = [container allKeys];
            values = [container allValues];
        }
        for (id obj in values)
        {
            if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
                [self.subNodes addObject:[[JSACNode alloc] initWithContainer:obj]];
            }
        }
        _actualStorage = container;
    }
    
    return self;
}

- (JSACNodeList *)nodesMatchingKeys:(NSArray<NSString *> *)keys {
    NSArray *matched = [self matchedNodesForKeys:keys];
    JSACNodeList *nodeList = [[JSACNodeList alloc] initWithNodes:matched];
    
    return nodeList;
}

+ (instancetype)nodeWithContainer:(id)container {
    return [[self alloc] initWithContainer:container];
}

#pragma mark - Setters / Getters
- (NSMutableArray<JSACNode *> *)subNodes {
    if (!_subNodes) {
        _subNodes = [NSMutableArray array];
    }
    
    return _subNodes;
}

#pragma mark - Private Methods
- (NSArray *)matchedNodesForKeys:(NSArray<NSString *> *)keys {
    NSArray *nodeKeys = [self isArray] ? [(JSACNode *)self.subNodes.firstObject keys] : self.keys;
    BOOL match = NO;
    for (NSString *key in nodeKeys)
    {
        if ([keys jsac_containsString:key]) {
            match = YES;
            break;
        }
    }
    
    if (match) {
        return [self isArray] ? [self subNodes] : @[self];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (JSACNode *node in self.subNodes)
    {
        NSArray *array = [node matchedNodesForKeys:keys];
        if (![array count])
            continue;
        
        if ([self isArray] || ![node isArray]) {
            [arr addObjectsFromArray:array];
        } else {
            [arr addObject:array];
        }
    }
    
    return [self isArray] ? [arr jsac_flattenedArray] : [arr copy];
}

- (BOOL)isArray {
    return self.keys == nil;
}

- (NSString *)description {
    return [self treeStringWithPrefix:@"" last:YES];
}

- (NSString *)treeStringWithPrefix:(NSString *)prefix last:(BOOL)last {
    NSMutableString *indent = [prefix mutableCopy];
    NSMutableString *treeString = [prefix mutableCopy];
    if (last) {
        [treeString appendString:@"\\-"];
        [indent appendString:@"  "];
    } else {
        [treeString appendString:@"|-"];
        [indent appendString:@"| "];
    }
    NSString *type = [self isArray] ? @"Array" : @"Object";
    [treeString appendString:type];
    [treeString appendFormat:@" %p", self];
    [treeString appendString:@"\n"];
    
    [self.subNodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [treeString appendString:[obj treeStringWithPrefix:indent last:idx == self.subNodes.count - 1]];
    }];
    
    return [treeString copy];
}

@end
