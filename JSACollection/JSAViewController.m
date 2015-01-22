//
//  JSAViewController.m
//  JSACollection
//
//  Created by Nelson LeDuc on 3/30/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import "JSAViewController.h"
#import "JSACCollectionSerializer.h"
#import "JSATestModelObject.h"

@interface JSAViewController ()

@end

@implementation JSAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /* I am performing this test in view did load, typically this 
     should occur on a background thread when coming back from a network
     request for JSON or file read for a plist.
     */
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"]];
    id testCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *testModelArray = [[JSACCollectionSerializer sharedInstance] generateModelObjectsWithSerializableClass:[JSATestModelObject class] fromContainer:testCollection];
    
    NSLog(@"%@", @([testModelArray count]));
    
}

@end
