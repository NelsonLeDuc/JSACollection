//
//  JSACNodeList.m
//  JSACollection
//
//  Created by Nelson LeDuc on 1/6/16.
//  Copyright © 2016 Nelson LeDuc. All rights reserved.
//

#import "JSACNodeList.h"
#import "JSACNode.h"

@interface JSACNodeList ()

@property (nonatomic, strong, readwrite) NSArray *nodes;

@end

@implementation JSACNodeList

- (instancetype)initWithNodes:(NSArray *)nodes
{
    self = [super init];
    if (self)
    {
        _nodes = [[self class] simplifiedArray:nodes];
    }
    
    return self;
}

+ (instancetype)nodeListWithNodes:(NSArray *)nodes
{
    return [[self alloc] initWithNodes:nodes];
}

#pragma mark - Private Methods
+ (NSArray *)simplifiedArray:(NSArray *)nodes
{
    id first = [nodes firstObject];
    if ([first isKindOfClass:[JSACNode class]])
    {
        return nodes;
    }
    else
    {
        id layer = first;
        while ([layer isKindOfClass:[NSArray class]])
        {
            if ([[layer firstObject] isKindOfClass:[JSACNode class]])
            {
                return layer;
            }
            
            layer = [layer firstObject];
        }
    }
    
    return @[];
}

@end
