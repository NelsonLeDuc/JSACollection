//
//  JSADataCollection.h
//  wildflower
//
//  Created by Nelson LeDuc on 8/1/13.
//  Copyright (c) 2013 Justin Ehlert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSACCollection : NSObject <NSFastEnumeration>

- (JSACCollection*)subCollectionFromKey:(id)key;
- (NSInteger)count;
- (BOOL)isEqualToCollection:(JSACCollection *)collection;

@end
