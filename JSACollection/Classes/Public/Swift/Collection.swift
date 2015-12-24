//
//  Collection.swift
//  JSACollection
//
//  Created by Nelson LeDuc on 12/23/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

import Foundation

public protocol SerializableContainer {}

extension NSDictionary: SerializableContainer {}
extension NSArray: SerializableContainer {}
extension Dictionary: SerializableContainer {}
extension Array: SerializableContainer {}


public func serializeObjects<C: SerializableContainer, T: NSObject>(container: C, type: T.Type = T.self, nonstandard: Bool = false) -> [T] {
    guard type != NSObject.self else { return [] }
    
    let serializer = JSACCollectionSerializer.sharedInstance()!
    serializer.allowNonStandardTypes = nonstandard
    let objects = serializer.generateModelObjectsWithSerializableClass(type, fromContainer: container as! AnyObject) as? [T]
    
    return objects ?? []
}

public func serializeObjects<C: SerializableContainer, M: JSACSerializableClassFactory>(container: C, mapper: M) -> [AnyObject] {
    let serializer = JSACCollectionSerializer.sharedInstance()!
    let objects = serializer.generateModelObjectsWithSerializableClassFactory(mapper, fromContainer: container as! AnyObject)
    
    return objects ?? []
}
