//
//  SwiftTest.swift
//  JSACollection
//
//  Created by Nelson LeDuc on 12/23/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

import XCTest
@testable import JSACollection

class SwiftTest: XCTestCase {
    
    var testCollection: NSDictionary!
    var topLevelCollection: NSDictionary!
    var middleCollection: NSDictionary!
    var parentTestCollection: NSDictionary!
    
    override func setUp() {
        super.setUp()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let firstJSON = NSData(contentsOfFile: bundle.pathForResource("test1", ofType: "json")!)!
        testCollection = try! NSJSONSerialization.JSONObjectWithData(firstJSON, options: []) as! NSDictionary
        
        let secondJSON = NSData(contentsOfFile: bundle.pathForResource("test2", ofType: "json")!)!
        topLevelCollection = try! NSJSONSerialization.JSONObjectWithData(secondJSON, options: []) as! NSDictionary
        
        let thirdJSON = NSData(contentsOfFile: bundle.pathForResource("test3", ofType: "json")!)!
        middleCollection = try! NSJSONSerialization.JSONObjectWithData(thirdJSON, options: []) as! NSDictionary
        
        let fourthJSON = NSData(contentsOfFile: bundle.pathForResource("test4", ofType: "json")!)!
        parentTestCollection = try! NSJSONSerialization.JSONObjectWithData(fourthJSON, options: []) as! NSDictionary
    }
    
    func testGenerateFromClass() {
        let models = serializeObjects(testCollection, type: JSATestModelObject.self, nonstandard: false)
        XCTAssertEqual(models.count, 2)
        
        let model = models.first
        XCTAssertEqual(model?.nameString, "Bob Jones")
        XCTAssertEqual(model?.testURL.absoluteString, "http://www.google.com");
        
        let modelNumArray = model?.randomArray as? [NSNumber]
        XCTAssertEqual(modelNumArray?.count, 3)
        XCTAssertEqual(modelNumArray![1].integerValue, 2)
        
        let homesArray = model?.homes as? [JSASubTestModelObject]
        XCTAssertEqual(homesArray?.count, 2);
        XCTAssertEqual(homesArray![0].homeName, "main");
        
        XCTAssertNil(model?.bestHome);
    }
    
    func testGenerateFromClassAllowNonStandard() {
        let models = serializeObjects(testCollection, type: JSATestModelObject.self, nonstandard: true)
        XCTAssertEqual(models.count, 2)
        
        let model = models.first
        XCTAssertEqual(model?.nameString, "Bob Jones")
        XCTAssertEqual(model?.testURL.absoluteString, "http://www.google.com");
        
        let modelNumArray = model?.randomArray as? [NSNumber]
        XCTAssertEqual(modelNumArray?.count, 3)
        XCTAssertEqual(modelNumArray![1].integerValue, 2)
        
        let homesArray = model?.homes as? [JSASubTestModelObject]
        XCTAssertEqual(homesArray?.count, 2);
        XCTAssertEqual(homesArray![0].homeName, "main");
        
        XCTAssertNotNil(model?.bestHome);
        XCTAssertEqual(model?.bestHome.homeName, "Walmart");
        
        XCTAssertNotNil(model?.bestHome.parentModelObject);
    }
    
    // MARK: - Object Mapper
    func testGenerateFromClassSubMapper() {
        let mapper = ObjectMapper(JSATestModelObject.self)
        mapper.allowNonStandard = true
        let subMapper = ObjectMapper(JSASubTestModelObject.self)
        subMapper.setterBlock = { (dict, object) in
            object.homeName = "My Fave"
            return object
        }
        mapper.addSubMapper("bestHome", mapper: subMapper)
        
        let models = serializeObjects(testCollection, mapper: mapper)
        XCTAssertEqual(models.count, 2);
        let model = models.first
        XCTAssertEqual(model?.nameString, "Bob Jones")
        XCTAssertEqual(model?.testURL.absoluteString, "http://www.google.com");
        
        let modelNumArray = model?.randomArray as? [NSNumber]
        XCTAssertEqual(modelNumArray?.count, 3)
        XCTAssertEqual(modelNumArray![1].integerValue, 2)
        
        let homesArray = model?.homes as? [JSASubTestModelObject]
        XCTAssertEqual(homesArray?.count, 2);
        XCTAssertEqual(homesArray![0].homeName, "main");
        
        XCTAssertNotNil(model?.bestHome);
        XCTAssertNil(model?.unused);
        XCTAssertEqual(model!.bestHome.homeName, "My Fave");
    }
    
}
