//
//  JSACKeyGenerator.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 12/17/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import "JSACKeyGenerator.h"
#import "NSObject+ListOfProperties.h"

static NSString * const kJSACollectionPropertyPrefix = @"jsc_";

@implementation JSACKeyGenerator

+ (NSDictionary *)keyListFromClass:(Class)class
{
    id obj = [[class alloc] init];
    NSArray *propeties = [obj listOfProperties];
    return [self generatedKeyListFromArray:propeties];
}

+ (NSDictionary *)standardKeyListFromClass:(Class)class
{
    id obj = [[class alloc] init];
    NSArray *propeties = [obj listOfStandardProperties];
    return [self generatedKeyListFromArray:propeties];
}

+ (NSDictionary *)nonStandardKeyListFromClass:(Class)class
{
    id obj = [[class alloc] init];
    NSArray *propeties = [obj listOfNonStandardProperties];
    return [self generatedKeyListFromArray:propeties];
}

+ (NSDictionary *)generatedKeyListFromArray:(NSArray *)array
{
    NSMutableDictionary *keyDict = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in array)
    {
        NSString *prop = propertyName;
        if ([[prop lowercaseString] hasPrefix:kJSACollectionPropertyPrefix] && [prop length] > [kJSACollectionPropertyPrefix length])
        {
            prop = [prop substringFromIndex:[kJSACollectionPropertyPrefix length]];
        }
        
        [keyDict setValue:propertyName forKey:prop];
        
        int indexOfUppercase = 0;
        for (int i = 0; i < prop.length && indexOfUppercase == 0; i++)
        {
            BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[prop characterAtIndex:i]];
            if (isUppercase)
                indexOfUppercase = i;
        }
        if (indexOfUppercase > 0)
        {
            NSString *firstWord = [prop substringToIndex:indexOfUppercase];
            [keyDict setValue:propertyName forKey:firstWord];
            
            NSMutableString *underscoredWords = [NSMutableString stringWithString:prop];
            NSMutableString *dashedWords = [NSMutableString stringWithString:prop];
            BOOL prevUppercase = NO;
            while (indexOfUppercase < [underscoredWords length])
            {
                BOOL uppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[underscoredWords characterAtIndex:indexOfUppercase]];
                if (uppercase && !prevUppercase)
                {
                    [underscoredWords insertString:@"_" atIndex:indexOfUppercase];
                    [dashedWords insertString:@"-" atIndex:indexOfUppercase];
                    indexOfUppercase++;
                }
                indexOfUppercase++;
                prevUppercase = uppercase;
            }
            [keyDict setValue:propertyName forKey:underscoredWords];
            [keyDict setValue:propertyName forKey:dashedWords];
        }
    }
    return [NSDictionary dictionaryWithDictionary:keyDict];
}

@end
