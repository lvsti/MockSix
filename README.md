# MockSix 

[![](https://api.travis-ci.org/lvsti/MockSix.svg?branch=master)](https://travis-ci.org/lvsti/MockSix)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MockSix.svg)](https://cocoapods.org/pods/MockSix)
![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20Linux-lightgrey.svg)

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

### Usage

##### Creating the mock implementation

1. Conform to Mock besides the actual protocol you are creating the mock for:

    ```swift
    class MockFoobar: FoobarProtocol, Mock {
    ```

2. Declare an enum for the methods ("method ID") you want to make available in the mock and set it for the `MockMethod` typealias:

    ```swift
        enum Methods: Int {
            case doThis
            case doThat
        }    
        typealias MockMethod = Methods
    ```
    
    The enum must have a `RawValue` of `Int`.

3. Implement the methods by calling through `registerInvocation` or `registerThrowingInvocation`:

    ```swift
        func doThis(_ string: String, _ number: Int) -> [Int] {
            return registerInvocation(for: .doThis, 
                                      args: string, number, 
                                      andReturn: [])
        }
        func doThat() throws -> Double {
            return registerThrowingInvocation(for: .doThat, 
                                              andReturn: 0.0)
        }
    ```
        
4. Define any properties mandated by the protocol:

    ```swift
        var stuff: Int = 0
    }
    ```

##### Using the mock

- call `resetMockSix()` at the beginning of each test (typically in a `beforeEach` block)

- instantiate and inject as usual:

    ```swift
    let foobar = MockFoobar()
    let sut = MyClass(foobar: foobar)
    ```
    
- stub methods by referring to their method ID:

    ```swift
    // return value override
    foobar.stub(.doThis, andReturn: [42])
    
    // replace implementation with closure
    foobar.stub(.doThis) { (args: [Any?]) in
        let num = args[1]! as! Int
        return [num]
    }
    foobar.stub(.doThat) { _ in
        if arc4random() % 2 == 1 { throw FoobarError.unknown }
        return 3.14
    }
    
    // invocation count aware stubbing
    foobar.stub(.doThis, andReturn: [42], times: 1, afterwardsReturn: [43])
    ```

    CAVEAT: the return value type must exactly match that of the function, e.g. to return a conforming `SomeClass` instance from a function with `SomeClassProtocol` return type, use explicit casting:
    
    ```swift
    foobar.stub(.whatever, andReturn: SomeClass() as SomeClassProtocol)
    ```

- remove stubs to restore the behavior defined in the mock implementation:

    ```swift
    foobar.unstub(.doThat)
    ```

- access raw invocation logs (if you really need to; otherwise you are better off with the [Nimble matchers](https://github.com/lvsti/NimbleMockSix)):

    ```swift
    // the mock has not been accessed
    foobar.invocations.isEmpty
    
    // doThis(_:_:) has been called twice
    foobar.invocations
        .filter { $0.methodID == MockFoobar.Methods.doThis.rawValue }
        .count == 2
    
    // doThis(_:_:) has been called with ("42", 42)
    !foobar.invocations
        .filter { 
            $0.methodID == MockFoobar.Methods.doThis.rawValue &&
            $0.args[0]! as! String == "42" &&
            $0.args[1]! as! Int == 42
        }
        .isEmpty
    ```

### Other stuff

I also wrote two blogposts about MockSix which may help you get started:

- [Lightweight Object Mocking in Swift](https://lvsti.github.io/cocoagrinder/2017/01/06/lightweight-object-mocking-in-swift.html): motivation and design decisions, and also an overview of the MockSix [Nimble matchers](https://github.com/lvsti/NimbleMockSix)
- [MockSix + Sourcery: Happily Ever After?](https://lvsti.github.io/cocoagrinder/2017/08/19/mocksix-sourcery.html): how to use [Sourcery](https://github.com/krzysztofzablocki/Sourcery) to automatically generate MockSix-style mocks without writing a single line of boilerplate

### Troubleshooting

- Invocation logs are showing unrelated calls => try calling `resetMockSix()` in the setup phase of each test case
- Test crashes with cast error => make sure the types of the returned values match the return type of the stubbed function; use explicit casting where required

### License

MockSix is released under the MIT license.