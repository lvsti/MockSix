//
//  MockSixInternal.swift
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

import Dispatch

// MARK: - common stuff

extension Mock where Self : AnyObject {
    public var mockSixLock: String {
        let ptr = Unmanaged.passUnretained(self).toOpaque()
        let address = Int(bitPattern: ptr)
        return "\(address)"
    }
}

extension Mock where MockMethod.RawValue == Int {
    private(set) public var invocations: [MockInvocation] {
        get { return mockQueue.sync { mockRecords[mockSixLock] ?? [] } }
        set { mockQueue.sync { mockRecords[mockSixLock] = newValue } }
    }
    
    public func resetMock() {
        mockQueue.sync {
            mockRecords[mockSixLock] = []
            mockBlocks[mockSixLock] = [:]
        }
    }
    
}

// MARK: - stubbing methods

extension Mock where MockMethod.RawValue == Int {

    fileprivate func identifier(for method: MockMethod) -> String {
        return "method-\(method.rawValue)"
    }
    
    private func registerStub<T>(for method: MockMethod, withBlock block: @escaping ([Any?]) throws -> T) {
        let id = identifier(for: method)
        mockQueue.sync {
            var blocks = mockBlocks[mockSixLock] ?? [:] as [String: Any]
            blocks[id] = block
            mockBlocks[mockSixLock] = blocks
        }
    }

    private func registerStub<T>(for method: MockMethod, withBlock block: @escaping ([Any?]) throws -> T?) {
        let id = identifier(for: method)
        mockQueue.sync {
            var blocks = mockBlocks[mockSixLock] ?? [:] as [String: Any]
            blocks[id] = block
            mockBlocks[mockSixLock] = blocks
        }
    }

    public func unstub(_ method: MockMethod) {
        let id = identifier(for: method)
        mockQueue.sync {
            var blocks = mockBlocks[mockSixLock] ?? [:] as [String: Any]
            blocks.removeValue(forKey: id)
            mockBlocks[mockSixLock] = blocks
        }
    }
    
    public func stub<T>(_ method: MockMethod, withBlock block: @escaping ([Any?]) throws -> T) {
        registerStub(for: method, withBlock: block)
    }

    public func stub<T>(_ method: MockMethod, withBlock block: @escaping ([Any?]) throws -> T?) {
        registerStub(for: method, withBlock: block)
    }

    public func stub<T>(_ method: MockMethod, andReturn value: T) {
        registerStub(for: method, withBlock: { _ in value })
    }

    public func stub<T>(_ method: MockMethod, andReturn value: T?) {
        registerStub(for: method, withBlock: { _ in value })
    }

    public func stub<T>(_ method: MockMethod, andReturn firstValue: T, times: Int, afterwardsReturn secondValue: T) {
        var count = 0
        registerStub(for: method, withBlock: { _ -> T in
            defer { count += 1 }
            return count < times ? firstValue : secondValue
        })
    }

    public func stub<T>(_ method: MockMethod, andReturn firstValue: T?, times: Int, afterwardsReturn secondValue: T?) {
        var count = 0
        registerStub(for: method, withBlock: { _ -> T? in
            defer { count += 1 }
            return count < times ? firstValue : secondValue
        })
    }

}

// MARK: - invocation proxies

extension Mock where MockMethod.RawValue == Int {

    private func registerInvocation<T>(for method: MockMethod,
                                       function: String = #function,
                                       args: [Any?],
                                       returns: ([Any?]) throws -> T? = { _ in nil }) throws -> T? {
        logInvocation(method: method, functionName: function, arguments: args)
        
        let id = identifier(for: method)
        let registeredStub = mockQueue.sync { mockBlocks[mockSixLock]?[id] }

        if let registeredStub = registeredStub {
            guard let typedStub = registeredStub as? ([Any?]) throws -> T? else {
                fatalError("MockSix: Incompatible block of type '\(type(of: registeredStub))' registered for function '\(function)' requiring block type '([Any?]) -> \(T.self)'")
            }
            return try typedStub(args)
        }
        else {
            return try returns(args)
        }
    }
    
    private func registerInvocation<T>(for method: MockMethod,
                                       function: String = #function,
                                       args: [Any?],
                                       returns: ([Any?]) throws -> T) throws -> T {
        logInvocation(method: method, functionName: function, arguments: args)
        
        let id = identifier(for: method)
        let registeredStub = mockQueue.sync { mockBlocks[mockSixLock]?[id] }

        if let registeredStub = registeredStub {
            guard let typedStub = registeredStub as? ([Any?]) throws -> T else {
                fatalError("MockSix: Incompatible block of type '\(type(of: registeredStub))' registered for function '\(function)' requiring block type '([Any?]) -> \(T.self)'")
            }
            return try typedStub(args)
        }
        else {
            return try returns(args)
        }
    }

    public func registerThrowingInvocation<T>(for method: MockMethod,
                                              function: String = #function,
                                              args: Any?...,
                                              returns: ([Any?]) throws -> T? = { _ in nil }) throws -> T? {
        return try registerInvocation(for: method, function: function, args: args, returns: returns)
    }

    public func registerThrowingInvocation<T>(for method: MockMethod,
                                              function: String = #function,
                                              args: Any?...,
                                              returns: ([Any?]) throws -> T) throws -> T {
        return try registerInvocation(for: method, function: function, args: args, returns: returns)
    }

    public func registerThrowingInvocation<T>(for method: MockMethod,
                                              function: String = #function,
                                              args: Any?...,
                                              andReturn value: T?) throws -> T? {
        return try registerInvocation(for: method, function: function, args: args, returns: { _ -> T? in value })
    }
    
    public func registerThrowingInvocation<T>(for method: MockMethod,
                                              function: String = #function,
                                              args: Any?...,
                                              andReturn value: T) throws -> T {
        return try registerInvocation(for: method, function: function, args: args, returns: { _ -> T in value })
    }

    public func registerThrowingInvocation(for method: MockMethod,
                                           function: String = #function,
                                           args: Any?...,
                                           returns: ([Any?]) throws -> Void = { _ in }) throws {
        logInvocation(method: method, functionName: function, arguments: args)
        
        let id = identifier(for: method)
        let registeredStub = mockQueue.sync { mockBlocks[mockSixLock]?[id] }
        
        if let registeredStub = registeredStub {
            guard let typedStub = registeredStub as? ([Any?]) throws -> Void else {
                fatalError("MockSix: Incompatible block of type '\(type(of: registeredStub))' registered for function '\(function)' requiring block type '([Any?]) -> ()'")
            }
            try typedStub(args)
        }
        else {
            try returns(args)
        }
    }

    public func registerInvocation<T>(for method: MockMethod,
                                      function: String = #function,
                                      args: Any?...,
                                      returns: ([Any?]) throws -> T? = { _ in nil }) -> T? {
        return try! registerInvocation(for: method, function: function, args: args, returns: returns)
    }

    public func registerInvocation<T>(for method: MockMethod,
                                   function: String = #function,
                                   args: Any?...,
                                   returns: ([Any?]) throws -> T) -> T {
        return try! registerInvocation(for: method, function: function, args: args, returns: returns)
    }

    public func registerInvocation<T>(for method: MockMethod,
                                      function: String = #function,
                                      args: Any?...,
                                      andReturn value: T?) -> T? {
        return try! registerInvocation(for: method, function: function, args: args, returns: { _ -> T? in value })
    }
    
    public func registerInvocation<T>(for method: MockMethod,
                                      function: String = #function,
                                      args: Any?...,
                                      andReturn value: T) -> T {
        return try! registerInvocation(for: method, function: function, args: args, returns: { _ -> T in value })
    }

    public func registerInvocation(for method: MockMethod,
                                   function: String = #function,
                                   args: Any?...,
                                   returns: ([Any?]) throws -> Void = { _ in }) {
        logInvocation(method: method, functionName: function, arguments: args)
        
        let id = identifier(for: method)
        let registeredStub = mockQueue.sync { mockBlocks[mockSixLock]?[id] }
        
        if let registeredStub = registeredStub {
            guard let typedStub = registeredStub as? ([Any?]) throws -> Void else {
                fatalError("MockSix: Incompatible block of type '\(type(of: registeredStub))' registered for function '\(function)' requiring block type '([Any?]) -> ()'")
            }
            try! typedStub(args)
        }
        else {
            try! returns(args)
        }
    }


    // Utility stuff
    private func logInvocation(method: MockMethod, functionName: String, arguments: [Any?]) {
        var invocations = [MockInvocation]()
        invocations.append(MockInvocation(methodID: method.rawValue, functionName: functionName, args: arguments))
        mockQueue.sync {
            if let existingInvocations = mockRecords[mockSixLock] {
                invocations = existingInvocations + invocations
            }
            mockRecords[mockSixLock] = invocations
        }
    }
}

public func resetMockSix() {
    mockQueue.sync {
        globalObjectIDIndex = 0
        mockRecords = [:]
        mockBlocks = [:]
    }
}


public func lock(prefix: String = #file + ":\(#line):") -> String {
    let suffix = mockQueue.sync { () -> String in
        globalObjectIDIndex += 1
        return "\(globalObjectIDIndex)"
    }
    return prefix + suffix
}


private var mockQueue: DispatchQueue = DispatchQueue(label: "MockSix")
private var globalObjectIDIndex: Int32 = 0
private var mockRecords: [String: [MockInvocation]] = [:]
private var mockBlocks: [String: [String: Any]] = [:]



// Testing
func fatalError(message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

struct FatalErrorUtil {
    static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure
    private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }
    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) { fatalErrorClosure = closure }
    static func restoreFatalError() { fatalErrorClosure = defaultFatalErrorClosure }
}
