//
//  JSACSerializableClassFactory.h
//  JSADataExample
//
//  Created by Nelson LeDuc on 8/22/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSACCollectionSerializer;

@protocol KeyValueAccessible <NSObject>

- (nullable id)valueForKey:(nonnull NSString *)key;

@end

@protocol JSACSerializableClassFactory <NSObject>
@required

- (nonnull NSArray *)listOfKeys;
- (nonnull id)objectForDictionary:(nonnull id<KeyValueAccessible>)dictionary forCollectionSerializer:(nonnull JSACCollectionSerializer *)serializer;

@end
