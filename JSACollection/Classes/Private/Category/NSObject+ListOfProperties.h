//
//  NSObject+ListOfProperties.h
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ListOfProperties)

- (NSArray *)listOfProperties;
- (NSArray *)listOfStandardProperties;
- (NSArray *)listOfNonStandardProperties;
- (Class)classForPropertyKey:(NSString *)key;
- (BOOL)setStandardValue:(id)value forKey:(NSString *)key;

@end
