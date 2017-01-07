//
//  MockSix.swift
//  MockSix
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Tamas Lustyik
//  Portions copyright (c) 2015-2016 Daniel Burbank
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//


/// Conform to 'Mock' to use MockSix.
///
/// For a function to be hooked by MockSix successfully, it must do three things: 
/// 1. pass its arguments to 'registerInvocation()'
/// 2. return the result of 'registerInvocation()', and 
/// 3. pass a closure that generates a default value. In practice, that looks like this:
/// ```swift
/// func myFunc(arg1: Int, arg2: String) -> String {
///     return registerInvocation(for: .myFunc, args: arg1, arg2) { "Default Return Value" }
/// }
/// ```
/// - requires: The line 'let mockSixLock = lock()' must be included if the
///             implementor is a struct. This registers the instance with MockSix.
public protocol Mock {
    /// The type that identifies methods of the mock object that MockSix may interact with. 
    /// This is typically an enum.
    /// Example:
    /// ```swift
    /// class MyClass: Mock {
    ///     enum Methods {
    ///         case myFunc
    ///     }
    ///     typealias MockMethod = Methods
    ///
    ///     func myFunc(arg1: Int, arg2: String) -> String {
    ///         return registerInvocation(for: .myFunc, args: arg1, arg2, andReturn: "Default Return Value")
    ///     }
    /// }
    /// ```
    associatedtype MockMethod : RawRepresentable

    /// Add `let mockSixLock = lock()` to your structs. (For classes it is not required.)
    /// This var holds the instance's unique identifier.
    var mockSixLock: String { get }
    
    /// Adds the signature of the containing function to `self.invocations` and 
    /// performs the block registered for `method`, if any. The return closure
    /// receives the method's arguments as an `[Any?]`.
    /// - parameter method: The method ID to register the invocation for.
    /// - parameter function: Set automatically to `#function`.
    /// - parameter args: The arguments passed to this method. Used for logging in `self.invocations`.
    /// - parameter returns: A closure to be executed by default when this function is invoked.
    func registerInvocation<T>(for method: MockMethod, function: String, args: Any?..., returns: ([Any?]) -> T?) -> T?

    /// Adds the signature of the containing function to `self.invocations` and
    /// performs the block registered for `method`, if any. The return closure
    /// receives the method's arguments as an `[Any?]`.
    /// - parameter method: The method ID to register the invocation for.
    /// - parameter function: Set automatically to `#function`.
    /// - parameter args: The arguments passed to this method. Used for logging in `self.invocations`.
    /// - parameter returns: A closure to be executed by default when this function is invoked.
    func registerInvocation<T>(for method: MockMethod, function: String, args: Any?..., returns: ([Any?]) -> T) -> T
    
    /// Adds the signature of the containing function to `self.invocations` and
    /// performs the block registered for `method`, if any. The return closure
    /// receives the method's arguments as an `[Any?]`.
    /// - parameter method: The method ID to register the invocation for.
    /// - parameter function: Set automatically to `#function`.
    /// - parameter args: The arguments passed to this method. Used for logging in `self.invocations`.
    /// - parameter value: A value to return with when this function is invoked.
    func registerInvocation<T>(for method: MockMethod, function: String, args: Any?..., andReturn value: T?) -> T?

    /// Adds the signature of the containing function to `self.invocations` and
    /// performs the block registered for `method`, if any. The return closure
    /// receives the method's arguments as an `[Any?]`.
    /// - parameter method: The method ID to register the invocation for.
    /// - parameter function: Set automatically to `#function`.
    /// - parameter args: The arguments passed to this method. Used for logging in `self.invocations`.
    /// - parameter value: A value to return with when this function is invoked.
    func registerInvocation<T>(for method: MockMethod, function: String, args: Any?..., andReturn value: T) -> T
    
    /// Adds the signature of the containing function to `self.invocations` and
    /// performs the block registered for `method`, if any. The return closure
    /// receives the method's arguments as an `[Any?]`.
    /// - parameter method: The method ID to register the invocation for.
    /// - parameter function: Set automatically to `#function`.
    /// - parameter args: The arguments passed to this method. Used for logging in `self.invocations`.
    /// - parameter returns: A closure to be executed by default when this function is invoked.
    func registerInvocation(for method: MockMethod, function: String, args: Any?..., returns: ([Any?]) -> Void)
    
    /// Unregisters all stubs and erases the invocation log
    func resetMock()

    /// When a method containing 'registerInvocation()' is called, an entry is appended
    /// to this array.
    var invocations: [MockInvocation] { get }

    /// Call this method to stub the method identified by `method`.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter block: A block with the same return type as the function being mocked. 
    ///                    If a closuer of the incorrect type is registered, a runtime error will result.
    func stub<T>(_ method: MockMethod, withBlock block: @escaping ([Any?]) -> T)

    /// Call this method to stub the method identified by `method`.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter block: A block with the same return type as the function being mocked. 
    ///                    If a closuer of the incorrect type is registered, a runtime error will result.
    func stub<T>(_ method: MockMethod, withBlock block: @escaping ([Any?]) -> T?)
    
    /// Call this method to stub the method identified by `method`.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter value: The value to return from the stub.
    func stub<T>(_ method: MockMethod, andReturn value: T)

    /// Call this method to stub the method identified by `method`.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter value: The value to return from the stub.
    func stub<T>(_ method: MockMethod, andReturn value: T?)
    
    /// Call this method to stub the method identified by `method` with multiple returns.
    /// The generated stub will return `firstValue` for `times` invocations, after which it switches over
    /// to `secondValue` and will keep returning that forever.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter firstValue: The value to return from the stub for the first `times` time.
    /// - parameter times: The count to return `firstValue` from the stub before switching over to `secondValue`.
    /// - parameter secondValue: The value to return from the stub beyond `times` invocations
    func stub<T>(_ method: MockMethod, andReturn firstValue: T, times: Int, afterwardsReturn secondValue: T)

    /// Call this method to stub the method identified by `method` with multiple returns.
    /// The generated stub will return `firstValue` for `times` invocations, after which it switches over
    /// to `secondValue` and will keep returning that forever.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be stubbed.
    /// - parameter firstValue: The value to return from the stub for the first `times` time.
    /// - parameter times: The count to return `firstValue` from the stub before switching over to `secondValue`.
    /// - parameter secondValue: The value to return from the stub beyond `times` invocations
    func stub<T>(_ method: MockMethod, andReturn firstValue: T?, times: Int, afterwardsReturn secondValue: T?)

    /// Call this method to remove a stub, and return a function to its default behavior.
    /// - parameter method: The identifier passed to `registerInvocation()` in the function to be reset.
    func unstub(_ method: MockMethod)
}


/// Structure to hold information of a function invocation.
public struct MockInvocation {
    /// Raw value of the method identifier
    public let methodID: Int
    
    /// Swift-style name of the invoked function
    public let functionName: String
    
    /// Arguments that the function was invoked with
    public let args: [Any?]
}

