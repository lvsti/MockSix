# MockSix template for Sourcery

Here I'm providing `Mockable.swifttemplate` to generate MockSix-style mock implementations with Sourcery. Here is how to use it:

1. Create a config file for Sourcery:

    ```yaml
    # mocksix.yml
    # all paths are relative to this file
    sources:
      - path/to/sources
    templates:
      - Mockable.swifttemplate
    output:
      generated_mocks.swift
   ```
   
2. Download and extract the [latest Sourcery package](https://github.com/krzysztofzablocki/Sourcery/releases/latest) (unfortunately the Homebrew distribution will not work)
3. Run Sourcery from the package:

    ```
    $ path/to/Sourcery-X.Y.Z/bin/sourcery --config path/to/mocksix.yml
    ```

The template will generate a mock class for each protocol found in `sources` that is annotated with `mockable` like so:

```swift
// sourcery:mockable
protocol ParserProtocol {
    func parse(_ string: String) -> [Int]
}
```

The generated code will look like this:

```swift
import MockSix

@testable import <# TARGET MODULE NAME #>

protocol DefaultInitializable {
    init()
}

class Dummy<T> {}

extension Dummy where T : DefaultInitializable {
    static var value: T { return T() }
}

class MockParser: ParserProtocol, Mock {
    enum Methods: Int {
        /// parse(_ string: String) -> [Int]
        case parse
    }    
    typealias MockMethod = Methods

    func parse(_ string: String) -> [Int] {
        return registerInvocation(for: .parse, 
                                  args: string, 
                                  andReturn: [])
    }
}
```

The template will emit a `Dummy<XXX>.value` reference for any nontrivial method return value and property initialization. Your job is to provide the missing extension for any referenced type. Examples:

```swift
// for types that have a default constructor: just conform to DefaultInitializable
extension String: DefaultInitializable {}
extension Int: DefaultInitializable {}

// for instantiable types
extension Dummy where T == MyStruct {
    static var value: T { 
        return MyStruct(some: "meaningful", default: .values) 
    }
}

// for protocol types: define a dummy, then the extension
class DummyForMyProtocol: MyProtocol { ... }

extension Dummy where T == MyProtocol {
    static var value: T { return DummyForMyProtocol() }
}
```

For some background, check out [this blogpost](https://lvsti.github.io/cocoagrinder/2017/08/19/mocksix-sourcery.html).