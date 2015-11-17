//
//  NSObject+ListOfProperties.m
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "NSObject+ListOfProperties.h"
#import <objc/runtime.h>
#import "JSACUtility.h"

NSString * const JSACUserInfoDateFormatterKey = @"dateFormatter";

@implementation NSObject (ListOfProperties)

#pragma mark - Public Methods

#pragma mark Class

+ (NSArray *)listOfProperties
{
    Class clazz = self;
    
    Class viewClass = NSClassFromString(@"UIView") ?: NSClassFromString(@"NSView");
    Class viewControllerClass = NSClassFromString(@"UIViewController") ?: NSClassFromString(@"NSViewController");
    NSArray *ignoreClasses = @[ [NSObject class], viewClass, viewControllerClass ];
    if ([ignoreClasses containsObject:clazz])
        return @[];
    
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        [propertyArray addObject:name];
    }
    
    free(properties);
    
    BOOL useParent = isParentPropertiesEnable(clazz);
    if (useParent)
    {
        NSArray *parentProperties = [[clazz superclass] listOfProperties];
        [propertyArray addObjectsFromArray:parentProperties];
    }
    
    return [NSArray arrayWithArray:propertyArray];
}

+ (NSArray *)listOfStandardProperties
{
    NSMutableArray *standardProperties = [NSMutableArray array];
    NSArray *properties = [self listOfProperties];
    
    for (NSString *property in properties)
    {
        if ([self isPropertyOfStandardType:property])
            [standardProperties addObject:property];
    }
    return [NSArray arrayWithArray:standardProperties];
}

+ (NSArray *)listOfNonStandardProperties
{
    NSMutableArray *nonStandardProperties = [NSMutableArray array];
    NSArray *properties = [self listOfProperties];
    
    for (NSString *property in properties)
    {
        if (![self isPropertyOfStandardType:property])
            [nonStandardProperties addObject:property];
    }
    return [NSArray arrayWithArray:nonStandardProperties];
}

+ (Class)classForPropertyKey:(NSString *)key
{
    NSString *type = [self typeOfProperty:key];
    Class clazz = NSClassFromString(type);
    return clazz;
}

#pragma mark Instance

- (NSArray *)listOfProperties
{
    return [[self class] listOfProperties];
}

- (NSArray *)listOfStandardProperties
{
    return [[self class] listOfStandardProperties];
}

- (NSArray *)listOfNonStandardProperties
{
    return [[self class] listOfNonStandardProperties];
}

- (Class)classForPropertyKey:(NSString *)key
{
    return [[self class] classForPropertyKey:key];
}

- (BOOL)setStandardValue:(id)value forKey:(NSString *)key
{
    return [self setStandardValue:value forKey:key userInfo:nil];
}

- (BOOL)setStandardValue:(id)value forKey:(NSString *)key userInfo:(NSDictionary *)userInfo
{
    if (value == nil || key == nil || value == [NSNull null])
        return NO;
    
    if ([self isPropertyOfStandardType:key])
    {
        NSString *type = [self typeOfProperty:key];
        if ([type isEqualToString:@"NSURL"])
        {
            [self setValue:[NSURL URLWithString:value] forKey:key];
        }
        else if ([type isEqualToString:@"NSDate"])
        {
            NSDate *date;
            if ([value isKindOfClass:[NSDate class]])
            {
                date = value;
            }
            else if ([value isKindOfClass:[NSString class]])
            {
                NSDateFormatter *formatter = userInfo[JSACUserInfoDateFormatterKey];
                date = [formatter dateFromString:value];
            }
            [self setValue:date forKey:key];
        }
        else
        {
            [self setValue:value forKey:key];
        }
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods

- (NSString *)typeOfProperty:(NSString *)propertyName
{
    return [[self class] typeOfProperty:propertyName];
}

+ (NSString *)typeOfProperty:(NSString *)propertyName
{
    Class clazz = self;
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    objc_property_t property = NULL;
    for (int i = 0; i < count ; i++)
    {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        if ([name isEqualToString:propertyName])
            property = properties[i];
    }
    
    if (!property)
        return [[clazz superclass] typeOfProperty:propertyName];
    
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding];
    free(properties);
    
    NSRange firstQuote = [propertyAttributes rangeOfString:@"@\""];
    if (firstQuote.location == NSNotFound)
        return @"primitive";
    NSRange secondQuote = [propertyAttributes rangeOfString:@"\"" options:0 range:NSMakeRange(firstQuote.location + firstQuote.length, [propertyAttributes length] - firstQuote.location - firstQuote.length)];
    NSRange typeRange = NSMakeRange(firstQuote.location + firstQuote.length, secondQuote.location - firstQuote.location - firstQuote.length);
    
    NSString *type = [propertyAttributes substringWithRange:typeRange];
    
    return type;
}

- (BOOL)isPropertyOfStandardType:(NSString *)propertyName
{
    NSString *type = [self typeOfProperty:propertyName];
    NSArray *allowedTypes = @[ @"NSString", @"NSURL", @"__NSCFDictionary", @"NSDictionary", @"primitive", @"NSArray", @"NSNumber", @"NSDate" ];

    return [allowedTypes containsObject:type];
}



@end
