# MockSix

MockSix is a microframework to make object mocking in Swift somewhat easier. MockSix is built upon [MockFive](https://github.com/DeliciousRaspberryPi/MockFive).

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
}
```

See the [Usage](#usage) section for more examples.

### Requirements

To build: Swift 3.+ <br/>
To use: macOS 10.10+, iOS 8.4+, tvOS 10+

### Installation

Via Carthage: add the following line to your Cartfile:

```
github "lvsti/MockSix"
```

Or just add `MockSix.swift` and `MockSixInternal.swift` to your test target.

### Usage

TODO

### License

MockSix is released under the Apache 2.0 license.