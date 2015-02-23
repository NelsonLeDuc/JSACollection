//
//  JSATestModelObject.h
//  JSACollection
//
//  Created by Nelson LeDuc on 3/31/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSACMacros.h"

@class JSASubTestModelObject;

@interface JSATestModelObject : NSObject

@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSURL *testURL;
@property (nonatomic, strong) NSArray *randomArray;
@property (nonatomic, strong) NSArray *homes; __MODEL_ARRAY(JSASubTestModelObject, homes);
@property (nonatomic, strong) JSASubTestModelObject *bestHome;
@property (nonatomic, strong) NSString *unused;

@end
