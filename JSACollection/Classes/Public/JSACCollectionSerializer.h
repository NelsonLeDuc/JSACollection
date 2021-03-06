//
//  JSAJSONSerializer.h
//  wildflower
//
//  Created by Nelson LeDuc on 6/17/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSACSerializableClassFactory;

@interface JSACCollectionSerializer : NSObject

/** Standard types include: NSString, NSURL, NSDictionary. 
    Setting this allows the model object to be created using 
    types that aren't standard. This will attempt to map the 
    values for the matching key to the object of the non-standard 
    type. This may cause errors when deserialzing. This field
    is ignored if you are using a class factory, or the 
    provided mapper.
 
    By default this is set to NO. 
 **/
@property (nonatomic, assign) BOOL allowNonStandardTypes;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

/** Convenience method to generate a shared instance.
 
    @return     The instance shared by the application.
 */
+ (instancetype)sharedInstance;

//The object passed as container should be an NSArray or NSDictionary type.
- (NSArray *)generateModelObjectsWithSerializableClass:(Class)class fromContainer:(id)container;
- (NSArray *)generateModelObjectsWithSerializableClassFactory:(id<JSACSerializableClassFactory>)serializableClassFactory fromContainer:(id)container;

@end
