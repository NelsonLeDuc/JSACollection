//
//  Mapper.swift
//  JSACollection
//
//  Created by Nelson LeDuc on 12/23/15.
//  Copyright © 2015 Nelson LeDuc. All rights reserved.
//

import Foundation

public class ObjectMapper<T: NSObject>: ClassSerializer {
    public typealias ObjectType = T
    
    public var allowNonStandard = false {
        didSet { _objectMapper.allowNonStandardTypes = allowNonStandard }
    }
    public var setterBlock: ((KeyValueAccessible, T) -> T?)? {
        didSet {
            let wrapper: JSACObjectMapperObjectSetterBlock?
            if let setter = setterBlock {
                wrapper = { (dict, object) in
                    guard let model = object as? T, let dict = dict else { return nil }
                    return setter(dict, model)
                }
            } else {
                wrapper = nil
            }
            _objectMapper.setterBlock = wrapper
        }
    }
    public var dateFormatter: NSDateFormatter? {
        didSet { _objectMapper.dateFormatter = dateFormatter }
    }
    
    public var customKeyDictionary: [String : String]? {
        didSet { _objectMapper.setCustomKeyDictionary(customKeyDictionary) }
    }
    
    public init(_ type: T.Type) {
    }
    
    public func addSetter(name: String, setterBlock: (AnyObject, T) -> Void) -> Self {
        //Work around for compiler crash
        let wrapper: JSACObjectMapperPropertySetterBlock = { (value, object) in
            if let value = value, let object = object as? T {
                setterBlock(value, object)
            }
        }
        _objectMapper.addSetterForPropertyWithName(name, withBlock: wrapper)
        return self
    }
    
    public func addSubMapper<S: NSObject>(name: String, mapper: ObjectMapper<S>) -> Self {
        _objectMapper.addSubObjectMapper(mapper._objectMapper, forPropertyName: name)
        return self
    }
    
    // MARK: ClassSerializer
    public func listOfKeys() -> [String] {
        return _objectMapper.listOfKeys() as? [String] ?? []
    }
    
    public func object(dictionary: KeyValueAccessible, serializer: JSACCollectionSerializer) -> ObjectType? {
        let object = _objectMapper.objectForDictionary(dictionary, forCollectionSerializer: serializer) as? ObjectType
        return object
    }
    
    internal let _objectMapper = JSACObjectMapper(forClass: T.self)
}
