# JSACollection

JSACollection is framework for converting collections (i.e. dictionaries, and arrays) into objective-c objects. This is useful in converting plists and JSON data into useable objective-c objects.

## First Steps

- [Download JSACollection](https://github.com/NelsonLeDuc/JSACollection/archive/master.zip) and look at the sample iPhone/iPad app.
- Check the file headers and read the guide below
- Comment or create pull requests to fix issues and get new features implemented.

## Installation

### CocoaPods

Add this to your Podfile:

	pod 'JSACollection', '~> 1.0'

Then run:
	
	pod install

## Getting Started

### Automatic Class Serialization

JSACollection is built around the `JSACollectionSerializer` class. The class manages converting `NSArrays` and `NSDictionaries` (which we will call collections) into an array of instances of a given class. The standard implementation would look something like this:

```obj-c
NSArray *arrayOfObjects = [[JSACCollectionSerializer sharedInstance] generateModelObjectsWithSerializableClass:[myClass class] fromContainer:myContainer];
```

Using this method, by default, the serializer will generate a mapping of the objects properties to values within the JSON. However, if the class defines the method `+(NSDictionary *)JSONKeyMapping` the serializer will use the mapping returned from this method, this mapping should be setup with the keys being the thing that exists in the collection and the values are the names of the properties to map to (note this should never be nil).

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

### Non-Standard Arrays

If a class has a property that is an array it will map an array from the collection directly to that field and thats it, which can be useful unless you want to have an array of `OtherFoo` instead of `NSString`. To fix this, in your header import `JSACMacros.h` and use the `__MODEL_ARRAY` macro. When implemented this will look like:
```obj-c
@interface Foo : NSObject

@property (nonatomic, strong) NSArray *otherFooArray; __MODEL_ARRAY(OtherFoo, otherFooArray);

@end
```
and thats it, your `otherFooArray` will now be full of `OtherFoo` objects.

## Requirements

JSACollection has only been tested for iOS 7.0+ but should be fully compatible with atleast iOS 6.

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
