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

/** Standard types include: NSString, NSURL, NSDictionary.
 Setting this allows the model object to be created using
 types that aren't standard. This will attempt to map the
 values for the matching key to the object of the non-standard
 type. This may cause errors when deserialzing. Note: The value
 will be propogated through unless a custom submapper is given.
 
 By default this is set to NO.
 **/
@property (nonatomic, assign) BOOL allowNonStandardTypes;

/** A block that returns an object to use for each dictionary, if a
 value is set for this it replaces the standard mapping system and
 only creates a plain instance before calling this block with the
 instantiated instance and the dictionary to map.
 
 By default this is set nil.
 **/
@property (nonatomic, copy) JSACObjectMapperObjectSetterBlock setterBlock;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

- (instancetype)initWithClass:(Class)clazz NS_DESIGNATED_INITIALIZER;

/** If a block is added for a property the mapper will call this block
 with the value mapped to the property instead of setting it on the
 object directly itself. If a block is set for a nonexistent property
 the mapper treats it as if it were a property and maps to it anyway.
 **/
- (void)addSetterForPropertyWithName:(NSString *)name withBlock:(JSACObjectMapperPropertySetterBlock)block;

/** If an object has an array or a model object mapped to one of its
 properties the mapper will parse the mapped value into a separate object,
 in order to control this more precisely you can set a custom sub-mapper
 for the named property.
 **/
- (void)addSubObjectMapper:(JSACObjectMapper *)mapper forPropertyName:(NSString *)name;

/** Allows setting of a custom key map so as to provide fine
 control of the mapping if needed. This will override the
 standard method of mapping keys, if you would like to stop
 using a custom one just set this value to nil.
 
 The key represents the collection value, the object is
 the name of the property.
 **/
- (void)setCustomKeyDictionary:(NSDictionary *)keyDictionary;

@end
