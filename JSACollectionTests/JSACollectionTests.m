//
//  JSACollectionTests.m
//  JSACollectionTests
//
//  Created by Nelson LeDuc on 3/30/14.
//  Copyright (c) 2014 Nelson LeDuc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JSACollection.h"
#import "JSATestModelObject.h"
#import "JSASubTestModelObject.h"

@interface JSACollectionTests : XCTestCase

@property (nonatomic, strong) JSACCollectionSerializer *serializer;
@property (nonatomic, strong) id testCollection;

@end

@implementation JSACollectionTests

- (void)setUp
{
    [super setUp];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSData *jsonData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"test1" ofType:@"json"]];
    self.testCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    self.serializer = [[JSACCollectionSerializer alloc] init];
}

- (void)tearDown
{
    self.serializer = [[JSACCollectionSerializer alloc] init];
    
    [super tearDown];
}

- (void)testGenerateFromClass
{
    self.serializer.allowNonStandardTypes = NO;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClass:[JSATestModelObject class] fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNil([model bestHome]);
}

- (void)testGenerateFromClassAllowNonStandard
{
    self.serializer.allowNonStandardTypes = YES;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClass:[JSATestModelObject class] fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNotNil([model bestHome]);
    XCTAssertEqualObjects([[model bestHome] homeName], @"Walmart");
}

#pragma mark - Object Mapper

- (void)testGenerateFromClassWithMapper
{
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    mapper.allowNonStandardTypes = NO;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNil([model bestHome]);
}

- (void)testGenerateFromClassAllowNonStandardWithMapper
{
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    mapper.allowNonStandardTypes = YES;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNotNil([model bestHome]);
    XCTAssertEqualObjects([[model bestHome] homeName], @"Walmart");
}

- (void)testGenerateFromClassWithMapperIgnoreSerializer
{
    self.serializer.allowNonStandardTypes = YES;
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    mapper.allowNonStandardTypes = NO;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNil([model bestHome]);
}

- (void)testGenerateFromClassAllowNonStandardWithMapperIgnoreSerializer
{
    self.serializer.allowNonStandardTypes = NO;
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    mapper.allowNonStandardTypes = YES;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNotNil([model bestHome]);
    XCTAssertEqualObjects([[model bestHome] homeName], @"Walmart");
}

@end
