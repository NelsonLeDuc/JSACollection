//
//  JSACMacros.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 1/29/14.
//  Copyright (c) 2014 Jump Space Apps. All rights reserved.
//

#import "JSACUtility.h"

//Macros to put into the JSAC_MODEL_CONFIGURE function
#define USE_PARENT_PROPERTIES enableParentProperties(self, YES)
#define MAP_ARRAY_CLASS(array, class) mapArrayToClassType(self, @#array, @#class)
#define ASSIGN_PARENT_REFERENCE(property) setParentPropertyName(self, @#property)

#define JSAC_MODEL_CONFIGURE(class, func) \
@interface class (JSAC__CONFIGURE) @end \
@implementation class (JSAC__CONFIGURE) \
+ (void)load\
{ func } \
@end

// Deprecated

#define __MODEL_ARRAY(class, array) @property (nonatomic, strong) class * MODEL_ARRAY_##array;
#define __MODEL_PARENT(prop) @property (nonatomic, strong) id MODEL_PARENT_##prop;
