//
//  JSACObjectMapper.h
//  JSACollection
//
//  Created by Nelson LeDuc on 2/19/15.
//  Copyright (c) 2015 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSACSerializableClassFactory.h"

typedef id(^JSACObjectMapperObjectSetterBlock)(NSDictionary *dict, id object);
typedef void(^JSACObjectMapperPropertySetterBlock)(id value, id object);

@interface JSACObjectMapper : NSObject <JSACSerializableClassFactory>

+ (instancetype)objectMapperForClass:(Class)clazz;

@property (nonatomic, assign) BOOL allowNonStandardTypes;
@property (nonatomic, copy) JSACObjectMapperObjectSetterBlock setterBlock;

- (instancetype)initWithClass:(Class)clazz NS_DESIGNATED_INITIALIZER;
- (void)addSetterForPropertyWithName:(NSString *)name withBlock:(JSACObjectMapperPropertySetterBlock)block;

@end
