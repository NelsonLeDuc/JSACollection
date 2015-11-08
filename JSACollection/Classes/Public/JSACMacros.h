//
//  JSACMacros.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 1/29/14.
//  Copyright (c) 2014 Jump Space Apps. All rights reserved.
//

#import "JSACUtility.h"

#define __USE_PARENT_PROPERTIES(class, enabled)         \
@interface class (JSAC_MODEL_USE_PARENT)                \
@end                                                    \
@implementation class (JSAC_MODEL_USE_PARENT)           \
+ (void)load {enableParentProperties(self, enabled);}   \
@end

#define __SET_PARENT_REFERENCE(class, property)         \
@interface class (JSAC_MODEL_PARENT_REF)                \
@end                                                    \
@implementation class (JSAC_MODEL_PARENT_REF)           \
+ (void)load {setParentPropertyName(self, @#property);} \
@end

#define __SET_ARRAY_CLASS(class, array, className)      \
@interface JSATestModelObject (JSAC_MODEL_##array)      \
@end                                                    \
@implementation JSATestModelObject (JSAC_MODEL_##array) \
+ (void)load                                            \
{                                                       \
mapArrayToClassType(self, @#array, @#className);        \
}                                                       \
@end

// Deprecated

#define __MODEL_ARRAY(class, array) @property (nonatomic, strong) class * MODEL_ARRAY_##array;
#define __MODEL_PARENT(prop) @property (nonatomic, strong) id MODEL_PARENT_##prop;
