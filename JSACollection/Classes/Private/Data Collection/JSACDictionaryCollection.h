//
//  JSADataDictionaryCollection.h
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSACCollection.h"

@interface JSACDictionaryCollection : JSACCollection

@property (nonatomic, strong, readonly) NSDictionary *dictionary;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
