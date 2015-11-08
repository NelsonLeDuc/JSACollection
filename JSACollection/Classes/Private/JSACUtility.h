//
//  JSACUtility.h
//  JSACollection
//
//  Created by Nelson LeDuc on 11/7/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>

void enableParentProperties(Class clazz, BOOL enabled);
BOOL isParentPropertiesEnable(Class clazz);

void mapArrayToClassType(Class clazz, NSString *arrayName, NSString *className);
NSDictionary *mappedArrayClassTypes(Class clazz);

void setParentPropertyName(Class clazz, NSString *propertyName);
NSString *parentPropertyName(Class clazz);
