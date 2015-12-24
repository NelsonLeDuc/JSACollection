//
//  SerializableContainer.swift
//  JSACollection
//
//  Created by Nelson LeDuc on 12/24/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

import Foundation

//Makes sure the container is a usable type
public protocol SerializableContainer {}
extension NSDictionary: SerializableContainer {}
extension NSArray: SerializableContainer {}
extension Dictionary: SerializableContainer {}
extension Array : SerializableContainer {}

extension SerializableContainer {
    public func serializeObjects<T: NSObject>(type: T.Type = T.self, nonstandard: Bool = false) -> [T] {
        return JSACollection.serializeObjects(self, type: type, nonstandard: nonstandard)
    }
    
    public func serializeObjects<M: ClassSerializer>(mapper: M) -> [M.ObjectType] {
        return JSACollection.serializeObjects(self, mapper: mapper)
    }
}
