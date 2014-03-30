//
//  JSACKeyGenerator.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 12/17/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import "JSACKeyGenerator.h"
#import "NSObject+ListOfProperties.h"

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
    for (NSString *prop in array)
    {
        [keyDict setValue:prop forKey:prop];
        [keyDict setValue:prop forKey:[prop lowercaseString]];
        [keyDict setValue:prop forKey:[prop capitalizedString]];
        [keyDict setValue:prop forKey:[prop uppercaseString]];
        NSString *firstLetter = [[prop substringToIndex:1] uppercaseString];
        NSString *firstLetterUppercase = [NSString stringWithFormat:@"%@%@", firstLetter, [prop substringFromIndex:1]];
        [keyDict setValue:prop forKey:firstLetterUppercase];
        
        int indexOfUppercase = 0;
        for (int i = 0; i < prop.length && indexOfUppercase == 0; i++)
        {
            BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[prop characterAtIndex:i]];
            if (isUppercase)
                indexOfUppercase = i;
        }
        if (indexOfUppercase > 0)
        {
            NSString *firstWord = [prop substringWithRange:NSMakeRange(0, indexOfUppercase)];
            [keyDict setValue:prop forKey:firstWord];
            [keyDict setValue:prop forKey:[firstWord lowercaseString]];
            [keyDict setValue:prop forKey:[firstWord capitalizedString]];
            [keyDict setValue:prop forKey:[firstWord uppercaseString]];
            firstLetter = [[firstWord substringToIndex:1] uppercaseString];
            firstLetterUppercase = [NSString stringWithFormat:@"%@%@", firstLetter, [firstWord substringFromIndex:1]];
            [keyDict setValue:prop forKey:firstLetterUppercase];
        }
    }
    return [NSDictionary dictionaryWithDictionary:keyDict];
}

@end
