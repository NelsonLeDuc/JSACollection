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
#import "JSATertiaryTestModelObject.h"
#import "JSAChildTestModel.h"

@interface JSACollectionTests : XCTestCase

@property (nonatomic, strong) JSACCollectionSerializer *serializer;
@property (nonatomic, strong) id testCollection;
@property (nonatomic, strong) id topLevelCollection;
@property (nonatomic, strong) id middleCollection;
@property (nonatomic, strong) id parentTestCollection;

@end

@implementation JSACollectionTests

- (void)setUp
{
    [super setUp];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSData *jsonData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"test1" ofType:@"json"]];
    self.testCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    jsonData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"test2" ofType:@"json"]];
    self.topLevelCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    jsonData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"test3" ofType:@"json"]];
    self.middleCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    jsonData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"test4" ofType:@"json"]];
    self.parentTestCollection = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
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
    XCTAssertEqualObjects([model jsc_id], @"test id");
    
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
    
    XCTAssertNotNil([[model bestHome] parentModelObject]);
}

- (void)testGenerateWithTopLevelObjects
{
    self.serializer.allowNonStandardTypes = NO;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClass:[JSATestModelObject class] fromContainer:self.topLevelCollection];
    
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

- (void)testGenerateFromClassWithMiddleLevelObjects
{
    self.serializer.allowNonStandardTypes = NO;
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClass:[JSATestModelObject class] fromContainer:self.middleCollection];
    
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

#pragma mark - Object Mapper

- (void)testGenerateFromClassSubMapper
{
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    mapper.allowNonStandardTypes = YES;
    JSACObjectMapper *subMapper = [JSACObjectMapper objectMapperForClass:[JSASubTestModelObject class]];
    [subMapper setSetterBlock:^id (id<KeyValueAccessible> dict, id object) {
        
        [object setHomeName:@"My Fave"];
        return object;
    }];
    
    [mapper addSubObjectMapper:subMapper forPropertyName:@"bestHome"];
    
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
    XCTAssertNil([model unused]);
    XCTAssertEqualObjects([[model bestHome] homeName], @"My Fave");
}

- (void)testGenerateFromClassWithMapperCustomSetter
{
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    [mapper setSetterBlock:^id (id<KeyValueAccessible> dict, id obj) {
        
        JSATestModelObject *model = obj;
        model.nameString = @"Test1";
        model.testURL = [NSURL URLWithString:@"http://www.apple.com"];
        model.randomArray = @[@1, @4, @7, @8];
        
        JSASubTestModelObject *subModel = [[JSASubTestModelObject alloc] init];
        subModel.homeName = @"My Home";
        JSASubTestModelObject *subModel2 = [[JSASubTestModelObject alloc] init];
        subModel2.homeName = @"My Home2";
        JSASubTestModelObject *subModel3 = [[JSASubTestModelObject alloc] init];
        subModel3.homeName = @"My Home3";
        JSASubTestModelObject *subModel4 = [[JSASubTestModelObject alloc] init];
        subModel4.homeName = @"My Home4";
        JSASubTestModelObject *subModel5 = [[JSASubTestModelObject alloc] init];
        subModel5.homeName = @"My Home5";
        model.homes = @[subModel, subModel2, subModel3, subModel4];
        model.bestHome = subModel5;
        
        return model;
    }];
    
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Test1");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.apple.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 4);
    XCTAssertEqual([modelNumArray[1] integerValue], 4);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 4);
    XCTAssertEqualObjects([homesArray[0] homeName], @"My Home");
    
    XCTAssertNotNil([model bestHome]);
    XCTAssertNil([model unused]);
}

- (void)testGenerateFromClassWithMapperCustomPropertySetter
{
    JSACObjectMapper *mapper = [JSACObjectMapper objectMapperForClass:[JSATestModelObject class]];
    [mapper addSetterForPropertyWithName:@"custom" withBlock:^(id value, id object) {
        
        [object setUnused:value];
    }];
    [mapper addSetterForPropertyWithName:@"nameString" withBlock:^(id value, id object) {
        
        [object setNameString:@"Replaced"];
    }];
    
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClassFactory:mapper fromContainer:self.testCollection];
    
    XCTAssertEqual([models count], 2);
    
    JSATestModelObject *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Replaced");
    XCTAssertEqualObjects([[model testURL] absoluteString], @"http://www.google.com");
    
    NSArray *modelNumArray = [model randomArray];
    XCTAssertEqual([modelNumArray count], 3);
    XCTAssertEqual([modelNumArray[1] integerValue], 2);
    
    NSArray *homesArray = [model homes];
    XCTAssertEqual([homesArray count], 2);
    XCTAssertEqualObjects([homesArray[0] homeName], @"main");
    
    XCTAssertNil([model bestHome]);
    XCTAssertNotNil([model unused]);
}

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
    
    XCTAssertEqualObjects([[[model bestHome] moreData] lastName], @"Smith");
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

- (void)testUseParentProperties
{
    NSArray *models = [self.serializer generateModelObjectsWithSerializableClass:[JSAChildTestModel class] fromContainer:self.parentTestCollection];
    
    JSAChildTestModel *model = [models firstObject];
    XCTAssertEqualObjects([model nameString], @"Bob Jones");
}

@end
