//
//  JSACMacros.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 1/29/14.
//  Copyright (c) 2014 Jump Space Apps. All rights reserved.
//

#define __MODEL_ARRAY(class, array) @property (nonatomic, strong) class * MODEL_ARRAY_##array;
#define __MODEL_PARENT(prop) @property (nonatomic, strong) id MODEL_PARENT_##prop;
