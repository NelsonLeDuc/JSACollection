//
//  NSObject+ListOfProperties.m
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import "NSObject+ListOfProperties.h"
#import <objc/runtime.h>

@implementation NSObject (ListOfProperties)

#pragma mark - Public Methods

- (NSArray *)listOfProperties
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        [propertyArray addObject:name];
    }
    
    free(properties);

    return [NSArray arrayWithArray:propertyArray];
}

- (NSArray *)listOfStandardProperties
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

- (NSArray *)listOfNonStandardProperties
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

- (Class)classForPropertyKey:(NSString *)key
{
    NSString *type = [self typeOfProperty:key];
    Class clazz = NSClassFromString(type);
    return clazz;
}

- (BOOL)setStandardValue:(id)value forKey:(NSString *)key
{
    if (value == nil || key == nil)
        return NO;
    
    if ([self isPropertyOfStandardType:key])
    {
        NSString *type = [self typeOfProperty:key];
        if ([type isEqualToString:@"NSURL"])
            [self setValue:[NSURL URLWithString:value] forKey:key];
        else
            [self setValue:value forKey:key];
        return YES;
    }
    
    return NO;
}

#pragma mark - Private Methods

- (NSString *)typeOfProperty:(NSString *)propertyName
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    objc_property_t property = NULL;
    for (int i = 0; i < count ; i++)
    {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSASCIIStringEncoding];
        if ([name isEqualToString:propertyName])
            property = properties[i];
    }
    
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
    
    if ([type isEqualToString:@"NSString"] || [type isEqualToString:@"NSURL"] || [type isEqualToString:@"__NSCFDictionary"] || [type isEqualToString:@"NSDictionary"] || [type isEqualToString:@"primitive"] | [type isEqualToString:@"NSArray"])
        return YES;
    return NO;
}



@end
