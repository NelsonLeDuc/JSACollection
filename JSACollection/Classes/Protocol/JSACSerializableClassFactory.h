//
//  JSACSerializableClassFactory.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/22/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSACCollectionSerializer;

@protocol JSACSerializableClassFactory <NSObject>
@required

- (NSArray *)listOfKeys;
- (id)objectForDictionary:(NSDictionary *)dictionary forCollectionSerializer:(JSACCollectionSerializer *)serializer;

@end
