# MockSix 

[![](https://travis-ci.org/lvsti/MockSix.svg?branch=master)](https://travis-ci.org/lvsti/MockSix/builds/188693467)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MockSix.svg)](https://cocoapods.org/pods/MockSix)
![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20OS%20X%20%7C%20tvOS%20-lightgrey.svg)

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
```

See the [Usage](#usage) section for more examples.

### Requirements

To build: Swift 3.+ <br/>
To use: macOS 10.10+, iOS 8.4+, tvOS 9.2+

### Installation

Via Cocoapods: add the following line to your Podfile:

```
pod 'MockSix'
```

Via Carthage: add the following line to your Cartfile:

```
github "lvsti/MockSix"
```

Or just add `MockSix.swift` and `MockSixInternal.swift` to your test target.

### Usage

TODO

### License

MockSix is released under the MIT license.