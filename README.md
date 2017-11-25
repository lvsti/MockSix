# MockSix 

[![](https://api.travis-ci.org/lvsti/MockSix.svg?branch=master)](https://travis-ci.org/lvsti/MockSix)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MockSix.svg)](https://cocoapods.org/pods/MockSix)
![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg)

MockSix is a microframework to make object mocking in Swift somewhat easier. MockSix is built upon Daniel Burbank's [MockFive](https://github.com/DeliciousRaspberryPi/MockFive).

If you are using Quick+Nimble, make sure you check out the Nimble matcher extensions at [NimbleMockSix](https://github.com/lvsti/NimbleMockSix) as well.

### Elevator pitch

MockSix simplifies manual object mocking by taking over some of the boilerplate and offering an API that is hard to use incorrectly.

Sample code:

```swift
// original interface
protocol MyClassProtocol {
   func myFunc(_ string: String) -> [Int]
}

// actual implementation
class MyClass: MyClassProtocol {
    func myFunc(_ string: String) -> [Int] {
        // ... whatever ...
        return result
    }
}

// mock implementation
class MockMyClass: MyClassProtocol, Mock {
    enum Methods: Int {
        case myFunc
    }    
    typealias MockMethod = Methods
    
    func myFunc(_ string: String) -> [Int] {
        return registerInvocation(for: .myFunc, 
                                  args: string, 
                                  andReturn: [])
    }
    
    init() {}
}

// in the test case
let mock = MockMyClass()
mock.myFunc("foobar") == []     // true
mock.stub(.myFunc, andReturn: [42])
mock.myFunc("foobar") == [42]   // true
mock.stub(.myFunc) { $0.isEmpty ? [] : [42] }
mock.myFunc("foobar") == [42]   // true
```

### Requirements

To build: Swift 4 <br/>
To use: macOS 10.10+, iOS 8.4+, tvOS 9.2+, Linux

### Installation

Via Cocoapods: add the following line to your Podfile:

```
pod 'MockSix'
```

Via Carthage: add the following line to your Cartfile (or Cartfile.private):

```
github "lvsti/MockSix"
```

Via the Swift Package Manager: add it to the dependencies in your Package.swift:

```swift
// swift-tools-version:4.0
let package = Package(
    name: "MyAwesomeApp",
    dependencies: [
        .package(url: "https://github.com/lvsti/MockSix", from: "0.1.7"),
        // ... other dependencies ...
    ],
    targets: [
        .target(name: "MyAwesomeApp", dependencies: []),
        .testTarget(
            name: "MyAwesomeAppTests",
            dependencies: ["MyAwesomeApp", "MockSix"]
        )
    ],
)
```

Or just add `MockSix.swift` and `MockSixInternal.swift` to your test target.

### Other stuff

I also wrote two blogposts about MockSix which may help you get started:

- [Lightweight Object Mocking in Swift](https://lvsti.github.io/cocoagrinder/2017/01/06/lightweight-object-mocking-in-swift.html): motivation and design decisions, and also an overview of the MockSix [Nimble matchers](https://github.com/lvsti/NimbleMockSix)
- [MockSix + Sourcery: Happily Ever After?](https://lvsti.github.io/cocoagrinder/2017/08/19/mocksix-sourcery.html): how to use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to automatically generate MockSix-style mocks without writing a single line of boilerplate

### License

MockSix is released under the MIT license.