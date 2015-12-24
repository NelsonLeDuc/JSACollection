# JSACollection

[![Version](https://img.shields.io/cocoapods/v/JSACollection.svg?style=flat)](http://cocoadocs.org/docsets/JSACollection)
[![License](https://img.shields.io/cocoapods/l/JSACollection.svg?style=flat)](http://cocoadocs.org/docsets/JSACollection)
[![Platform](https://img.shields.io/cocoapods/p/JSACollection.svg?style=flat)](http://cocoadocs.org/docsets/JSACollection)

JSACollection is framework for converting collections (i.e. dictionaries, and arrays) into objective-c objects. This is useful in converting plists and JSON data into useable objective-c objects.

## First Steps

- [Download JSACollection](https://github.com/NelsonLeDuc/JSACollection/archive/master.zip) and look at the sample iPhone/iPad app.
- Check the file headers and read the guide below
- Comment or create pull requests to fix issues and get new features implemented.

## Installation

### CocoaPods

Add this to your Podfile for Objective-C:

	pod 'JSACollection', '~> 1.6.0.beta'

Or this for Swift:

    pod 'JSACollection/Swift', '~> 1.6.0.beta'

Then run:
	
	pod install

## Getting Started

### Swift Wrapper

> For information on how the serialization works read the sections below, this is a basic explanation of the Swift wrapper.

Currently two top-level functions are provided to cover the majority of used functionality in a Swift-y way. There are as follows:
```swift
func serializeObjects<C: SerializableContainer, T: NSObject>(container: C, type: T.Type = T.self, nonstandard: Bool = false) -> [T]
func serializeObjects<C: SerializableContainer, M: JSACSerializableClassFactory>(container: C, mapper: M) -> [AnyObject]
```
The first function has a few parameters for customization, but at its simplest it only requires a container (Dictionary or Array):
```swift
let objects: [Foo] = serializeObjects(["name": "bill"])
```
Since the assignment is to an array of ```Foo``` the compiler can infer the type, if you this isn't possible in your situation you can pass in the type explicitly:
```swift
let objects = serializeObjects(["name": "bill"], type: Foo.self)
```
Finally you can determine if nonstandard types are supported through a separate optional parameter.
```swift
let objects: [Foo] = serializeObjects(["name": "bill"], nonstandard = true)
```

The other function simply takes in a container and a mapper which conforms to the ```JSACSerializableClassFactory```, which behaves the same as before and still allows use of the ```JSACObjectMapper``` for whatever customization you need.

### Automatic Class Serialization

JSACollection is built around the `JSACollectionSerializer` class. The class manages converting `NSArrays` and `NSDictionaries` (which we will call collections) into an array of instances of a given class. The standard implementation would look something like this:

```obj-c
NSArray *arrayOfObjects = [[JSACCollectionSerializer sharedInstance] generateModelObjectsWithSerializableClass:[myClass class] fromContainer:myContainer];
```

Using this method, by default, the serializer will generate a mapping of the objects properties to values within the JSON. However, if the class defines the method `+(NSDictionary *)JSONKeyMapping` the serializer will use the mapping returned from this method, this mapping should be setup with the keys being the thing that exists in the collection and the values are the names of the properties to map to (note this should never be nil).

### Serialization Using The Mapper

JSACollection provides a mapper class JSACObjectMapper to provide users of the API to adjust how the mapping occurs. There are a couple of provided methods to facilitate this.

```obj-c
[mapper setSetterBlock:^id (NSDictionary *dict, id obj) {
    //Perform custom object mapping
}];
```

This replaces the mapping mechanism of the mapper, when a dictionary that represents the object is found it will call this block with the dictionary and a newly instantiated object. The value returned will be used instead of the obj passed in if you would like to call a different initializer or other logic.

```obj-c
[mapper addSetterForPropertyWithName:@"custom" withBlock:^(id value, id object) {
    //Perform custom property mapping
}];
```

This enables you to do something when mapping a field to a property, if the provided name is already a property on the object it will not set it and just call this block. However, if the name is not a property on the object it will still map and call the block with the value as if it were a property.

```obj-c 
[mapper addSubObjectMapper:subMapper forPropertyName:@"bestHome"];
```

Whenever an array of objects is parsed, or a non-standard property needs to be mapped the mapper will get called again, if you would like to augment this behavior a sub-mapper can be provided through this method. 

### Serialization Using A Factory

Alternatively, instead of leaving the creation up to the serializer, one can provide a factory that provides a list of keys and will create an object when given a dictionary. This will end up looking like:

```obj-c
NSArray *arrayOfObjects = [[JSACCollectionSerializer sharedInstance] generateModelObjectsWithSerializableClassFactory:myFactory fromContainer:myContainer];
```

To create a factory, the object should conform to the `JSACSerializableClassFactory` protocol and implement the two methods; `-(NSArray *)listOfKeys` and `-(id)objectForDictionary:(NSDictionary *)dictionary`.

## Advanced

### Non-Standard Types

Normally the serializer will only attempt to map properties from JSON if the property type is `NSString`, `NSURL`, `NSDictionary`, `NSArray`, or one the primitive types. However the serializer has the property `allowNonStandardTypes` which is of type `BOOL`. By default this is set to `NO`, but if this is changed to be `YES`it allows the serializer to attempt to map keys to object types. 

Example: Imagine you have an object that is structured like so
```obj-c
@interface Foo : NSObject

@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) OtherFoo *otherFoo;

@end
```
and imagine your collection is structured like this
```JSON
{
    "nameString" : "Bob",
    "otherFoo" : { "fooString" : "Foo", "fooType" : "strong" }
}
```
on the Foo object the `nameString` will be set to `"Bob"` and the `otherFoo` field will be set to an object with its `fooString` field set to `"Foo"` and its `fooType` field set to `"strong"`.

## Model Configuration

Using provided macros you can allow the mapper to perform more advanced operations to map more correctly and to more complicated structures.
```obj-c
JSAC_MODEL_CONFIGURE(Foo, {
    USE_PARENT_PROPERTIES;
    MAP_ARRAY_CLASS(arrayName, className);
    ASSIGN_PARENT_REFERENCE(propertyName);
})
```

The macros do the following:

- Allow mapping to use the superclass properties
- Map an object to an NSArray, much like generics
- Mark a property as being a reference to the parent object

### Non-Standard Arrays

If a class has a property that is an array it will map an array from the collection directly to that field and thats it, which can be useful unless you want to have an array of `OtherFoo` instead of `NSString`. To fix this, in your header import `JSACMacros.h` and use the `MAP_ARRAY_CLASS` macro. When implemented this will look like:
```obj-c
@interface Foo : NSObject

@property (nonatomic, strong) NSArray *otherFooArray;

@end

JSAC_MODEL_CONFIGURE(Foo, {
    MAP_ARRAY_CLASS(otherFooArray, OtherFoo);
})
```
and thats it, your `otherFooArray` will now be full of `OtherFoo` objects.

### Parent Objects

If a class has a non-standard object on it and you would like that object to have a reference to its parent object simply use the provided macro. In your header import `JSACMacros.h` and use the `ASSIGN_PARENT_REFERENCE` macro, which will look like below when implemented.
```obj-c
@interface Foo : NSObject

@property (nonatomic, strong) id parent;

@end

JSAC_MODEL_CONFIGURE(Foo, {
    ASSIGN_PARENT_REFERENCE(parent);
})
```
thats all you need to do, the parent property will now hold a reference to Foo's parent object.

## Details

### Property Naming

The way that property names map to fields contained within the collection is as follows (all of these are case insensitive):

- Names will map directly to fields with the same name.
- The first word of a name will map to a field with that name. (e.g. nameString will map to name)
- The words of a name seperated by underscores will map to a corresponding field. (e.g. firstName will map to first_name)

## Requirements

JSACollection has only been tested for iOS 7.0+ but should be fully compatible with atleast iOS 6, except when using Swift which requires iOS 8.0+.

ARC is required. For projects that don't use ARC, you can set the `-fobjc-arc` compiler flag on the relevant files.

## Problems?

Please feel free to open an [issue](https://github.com/NelsonLeDuc/JSACollection/issues), or submit a pull request.

## License

Copyright (c) 2014 Nelson LeDuc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
