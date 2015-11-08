//
//  JSACUtility.m
//  JSACollection
//
//  Created by Nelson LeDuc on 11/7/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSACUtility.h"
#import <objc/runtime.h>

static char kAssociatedParentPropertyKey;
static char kAssociatedArrayTypeKey;
static char kAssociatedParentProperty;

void enableParentProperties(Class clazz, BOOL enabled)
{
    objc_setAssociatedObject(clazz, &kAssociatedParentPropertyKey, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

BOOL isParentPropertiesEnable(Class clazz)
{
    NSNumber *number = objc_getAssociatedObject(clazz, &kAssociatedParentPropertyKey);
    
    if (!number) {
        return NO;
    }
    
    return [number boolValue];
}

void mapArrayToClassType(Class clazz, NSString *arrayName, NSString *className)
{
    NSMutableDictionary *dict = [mappedArrayClassTypes(clazz) mutableCopy];
    
    dict[arrayName] = className;
    
    objc_setAssociatedObject(clazz, &kAssociatedArrayTypeKey, [dict copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSDictionary *mappedArrayClassTypes(Class clazz)
{
    return objc_getAssociatedObject(clazz, &kAssociatedArrayTypeKey) ?: @{};
}

void setParentPropertyName(Class clazz, NSString *propertyName)
{
    objc_setAssociatedObject(clazz, &kAssociatedParentProperty, propertyName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

NSString *parentPropertyName(Class clazz)
{
    return objc_getAssociatedObject(clazz, &kAssociatedParentProperty);
}
