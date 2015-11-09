//
//  JSASubTestModelObject.h
//  JSACollection
//
//  Created by Nelson LeDuc on 2/22/15.
//  Copyright (c) 2015 Nelson LeDuc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSACMacros.h"

@class JSATertiaryTestModelObject;

@interface JSASubTestModelObject : NSObject

@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) JSATertiaryTestModelObject *moreData;
@property (nonatomic, weak) id parentModelObject;

@end

JSAC_MODEL_CONFIGURE(JSASubTestModelObject, {
    ASSIGN_PARENT_REFERENCE(parentModelObject);
})
