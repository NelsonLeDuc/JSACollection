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
    NSArray *properties = [class listOfProperties];
    return [self generatedKeyListFromArray:properties];
}

+ (NSDictionary *)standardKeyListFromClass:(Class)class
{
    NSArray *properties = [class listOfStandardProperties];
    return [self generatedKeyListFromArray:properties];
}

+ (NSDictionary *)nonStandardKeyListFromClass:(Class)class
{
    NSArray *properties = [class listOfNonStandardProperties];
    return [self generatedKeyListFromArray:properties];
}

+ (NSDictionary *)generatedKeyListFromArray:(NSArray *)array
{
    NSMutableDictionary *keyDict = [[NSMutableDictionary alloc] init];
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:nil];
    
    for (NSString *propertyName in array)
    {
        NSString *prop = propertyName;
        if ([[prop lowercaseString] hasPrefix:kJSACollectionPropertyPrefix] && [prop length] > [kJSACollectionPropertyPrefix length]) {
            prop = [prop substringFromIndex:[kJSACollectionPropertyPrefix length]];
        }
        
        NSTextCheckingResult *first = [regexp firstMatchInString:prop options:0 range:NSMakeRange(0, prop.length)];
        NSString *firstWord = [prop substringToIndex:first.range.location + 1];
        if (first && firstWord) {
            keyDict[firstWord] = propertyName;
        }
        
        NSString *underscores = [regexp stringByReplacingMatchesInString:propertyName options:0 range:NSMakeRange(0, propertyName.length) withTemplate:@"$1_$2"];
        NSString *dashes = [regexp stringByReplacingMatchesInString:propertyName options:0 range:NSMakeRange(0, propertyName.length) withTemplate:@"$1-$2"];
        if (underscores) {
            keyDict[underscores] = propertyName;
        }
        if (dashes) {
            keyDict[dashes] = propertyName;
        }
        
        keyDict[propertyName] = propertyName;
    }
    
    return [keyDict copy];
}

@end
