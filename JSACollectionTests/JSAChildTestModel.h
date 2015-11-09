//
//  JSAChildTestModel.h
//  JSACollection
//
//  Created by Nelson LeDuc on 11/8/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

#import "JSAParentTestModel.h"
#import "JSACMacros.h"

@interface JSAChildTestModel : JSAParentTestModel

@end

JSAC_MODEL_CONFIGURE(JSAChildTestModel, {
    USE_PARENT_PROPERTIES;
})

