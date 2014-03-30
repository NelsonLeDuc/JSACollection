//
//  JSACSerializableClassFactory.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/22/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSACSerializableClassFactory <NSObject>
@required

- (NSArray *)listOfKeys;
- (id)objectForDictionary:(NSDictionary *)dictionary;

@end
