//
//  Collection.swift
//  JSACollection
//
//  Created by Nelson LeDuc on 12/23/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

import Foundation

public protocol ClassSerializer {
    typealias ObjectType: NSObject
    
    func listOfKeys() -> [String]
    func object(dictionary: KeyValueAccessible, serializer: JSACCollectionSerializer) -> ObjectType?
}

public func serializeObjects<C: SerializableContainer, T: NSObject>(container: C, type: T.Type = T.self, nonstandard: Bool = false) -> [T] {
    guard type != NSObject.self else { return [] }
    
    let serializer = JSACCollectionSerializer.sharedInstance()!
    serializer.allowNonStandardTypes = nonstandard
    let objects = serializer.generateModelObjectsWithSerializableClass(type, fromContainer: container as! AnyObject) as? [T]
    
    return objects ?? []
}

public func serializeObjects<C: SerializableContainer, M: ClassSerializer>(container: C, mapper: M) -> [M.ObjectType] {
    let serializer = JSACCollectionSerializer.sharedInstance()!

    // Get around issues with generic constraints in a protocol
    let keyGenerator = M.listOfKeys(mapper)
    let objectCreator = M.object(mapper)
    let wrapper = SerializableClassFactoryWrapper(keyGenerator: keyGenerator, objectCreator: objectCreator)
    
    let objects = serializer.generateModelObjectsWithSerializableClassFactory(wrapper, fromContainer: container as! AnyObject) as? [M.ObjectType]
    
    return objects ?? []
}



// MARK: - Private
@objc
private class SerializableClassFactoryWrapper: NSObject, JSACSerializableClassFactory {
    private let keyGenerator: () -> [String]
    private let objectCreator: (KeyValueAccessible, JSACCollectionSerializer) -> AnyObject?
    
    private init(keyGenerator: () -> [String], objectCreator: (KeyValueAccessible, JSACCollectionSerializer) -> AnyObject?) {
        self.keyGenerator = keyGenerator
        self.objectCreator = objectCreator
    }
    // MARK: JSACSerializableClassFactory
    @objc private func listOfKeys() -> [AnyObject] {
        return self.keyGenerator()
    }
    
    @objc private func objectForDictionary(dictionary: KeyValueAccessible, forCollectionSerializer serializer: JSACCollectionSerializer) -> AnyObject? {
        return objectCreator(dictionary, serializer)
    }
}
