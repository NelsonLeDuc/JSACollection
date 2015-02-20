//
//  JSADataCollectionFactory.h
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSACCollection;

@interface JSACCollectionFactory : NSObject

+ (BOOL)usableTypeOfCollection:(id)collection;
+ (JSACCollection*)collectionWithObject:(id)collection;
+ (JSACCollection *)generateUsableCollectionFromCollection:(JSACCollection *)collection;

@end
