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
        [self addSimilarStringsToDictionary:keyDict forString:prop];
        
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
            [self addSimilarStringsToDictionary:keyDict forString:firstWord];
            
            NSMutableString *underscoredWords = [NSMutableString stringWithString:prop];
            while (indexOfUppercase < [underscoredWords length])
            {
                if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[underscoredWords characterAtIndex:indexOfUppercase]])
                {
                    [underscoredWords insertString:@"_" atIndex:indexOfUppercase];
                    indexOfUppercase++;
                }
                indexOfUppercase++;
            }
            [self addSimilarStringsToDictionary:keyDict forString:underscoredWords];
        }
    }
    return [NSDictionary dictionaryWithDictionary:keyDict];
}

#pragma mark - Private Methods

+ (void)addSimilarStringsToDictionary:(NSMutableDictionary *)dictionary forString:(NSString *)string
{
    [dictionary setValue:string forKey:string];
    [dictionary setValue:string forKey:[string lowercaseString]];
    [dictionary setValue:string forKey:[string capitalizedString]];
    [dictionary setValue:string forKey:[string uppercaseString]];
    NSString *firstLetter = [[string substringToIndex:1] uppercaseString];
    NSString *firstLetterUppercase = [NSString stringWithFormat:@"%@%@", firstLetter, [string substringFromIndex:1]];
    [dictionary setValue:string forKey:firstLetterUppercase];
}

@end
