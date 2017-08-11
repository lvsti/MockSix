//
//  MockSixTests.swift
//  MockSixTests
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Tamas Lustyik
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

import Quick
import Nimble
import MockSix

class MockDummy: Mock {
    enum Methods: Int {
        case myFunc
        case myOtherFunc
    }
    typealias MockMethod = Methods
    
    init() {
    }
}

enum DummyError: Error {
    case somethingBadHappened
}


class MockSixSpec: QuickSpec {
    override func spec() {
        let dummy = MockDummy()
        
        beforeEach {
            dummy.resetMock()
        }
        
        describe("registering invocations") {
            
            context("non-throwing function") {
                context("returning a direct T value") {
                    it("returns the specified return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: [42])
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = dummy.registerInvocation(for: .myFunc, andReturn: [42])
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }
                    
                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = dummy.registerInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14, andReturn: [42])
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }

                context("returning a direct T? value") {
                    it("returns the specified return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: [42] as [Int]?)
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = dummy.registerInvocation(for: .myFunc, andReturn: [42] as [Int]?)
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }

                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = dummy.registerInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14, andReturn: [42] as [Int]?)
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }
            
                context("returning a T value with closure") {
                    it("returns the specified return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc) { _ in [42] }
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = dummy.registerInvocation(for: .myFunc) { _ in [42] }
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }

                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = dummy.registerInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in [42] }
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }

                context("returning a T? value with closure") {
                    it("returns the specified return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc) { _ in [42] as [Int]? }
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = dummy.registerInvocation(for: .myFunc) { _ in [42] as [Int]? }
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }

                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = dummy.registerInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in [42] as [Int]? }
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }

                context("returning void with a closure") {
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            dummy.registerInvocation(for: .myFunc)
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }

                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = dummy.registerInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in }
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }
            }
            
            context("throwing function") {
                context("returning a direct T value") {
                    it("returns the specified return value") {
                        // when
                        let result = try! dummy.registerThrowingInvocation(for: .myFunc, andReturn: [42])
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = try! dummy.registerThrowingInvocation(for: .myFunc, andReturn: [42])
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }
                    
                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = try! dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14, andReturn: [42])
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }
                
                context("returning a direct T? value") {
                    it("returns the specified return value") {
                        // when
                        let result = try! dummy.registerThrowingInvocation(for: .myFunc, andReturn: [42] as [Int]?)
                        
                        // then
                        expect(result) == [42]
                    }
                    
                    it("captures the enclosing function name for the invocation") {
                        // given
                        func nestedFunc() {
                            _ = try! dummy.registerThrowingInvocation(for: .myFunc, andReturn: [42] as [Int]?)
                        }
                        
                        // when
                        nestedFunc()
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                    }
                    
                    it("captures the method ID and arguments for the invocation") {
                        // when
                        _ = try! dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14, andReturn: [42] as [Int]?)
                        
                        // then
                        expect(dummy.invocations).to(haveCount(1))
                        let invocation = dummy.invocations.first!
                        expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                        expect(invocation.args).to(haveCount(4))
                        expect(invocation.args[0] as! String?).to(equal("aaa"))
                        expect(invocation.args[1] as! Int?).to(equal(42))
                        expect(invocation.args[2]).to(beNil())
                        expect(invocation.args[3] as! Double?).to(equal(3.14))
                    }
                }
                
                context("returning a T value with closure") {
                    
                    context("the closure returns normally") {

                        it("returns the specified return value") {
                            // when
                            let result = try! dummy.registerThrowingInvocation(for: .myFunc) { _ in [42] }
                            
                            // then
                            expect(result) == [42]
                        }
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() {
                                _ = try! dummy.registerThrowingInvocation(for: .myFunc) { _ in [42] }
                            }
                            
                            // when
                            nestedFunc()
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            _ = try! dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in [42] }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }

                    }
                    
                    context("the closure throws") {
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() throws {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc) { _ -> [Int] in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            
                            // when
                            do {
                                try nestedFunc()
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ -> [Int] in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }
                        
                        it("rethrows the error") {
                            // given
                            var didThrow = false
                            
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ -> [Int] in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                                didThrow = true
                            }
                            
                            // then
                            expect(didThrow).to(beTrue())
                        }
                        
                    }

                }
                
                context("returning a T? value with closure") {

                    context("the closure returns normally") {
                        
                        it("returns the specified return value") {
                            // when
                            let result = try! dummy.registerThrowingInvocation(for: .myFunc) { _ in [42] as [Int]? }
                            
                            // then
                            expect(result) == [42]
                        }
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() {
                                _ = try! dummy.registerThrowingInvocation(for: .myFunc) { _ in [42] as [Int]? }
                            }
                            
                            // when
                            nestedFunc()
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            _ = try! dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in [42] as [Int]? }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }
                        
                    }
                    
                    context("the closure throws") {
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() throws {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc) { _ -> [Int]? in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            
                            // when
                            do {
                                try nestedFunc()
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ -> [Int]? in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }
                        
                        it("rethrows the error") {
                            // given
                            var didThrow = false
                            
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ -> [Int]? in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                                didThrow = true
                            }
                            
                            // then
                            expect(didThrow).to(beTrue())
                        }
                        
                    }
                
                }
                
                context("returning void with a closure") {

                    context("the closure returns normally") {
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() {
                                _ = try! dummy.registerThrowingInvocation(for: .myFunc) { _ in }
                            }
                            
                            // when
                            nestedFunc()
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            _ = try! dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }
                        
                    }
                    
                    context("the closure throws") {
                        
                        it("captures the enclosing function name for the invocation") {
                            // given
                            func nestedFunc() throws {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc) { _ in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            
                            // when
                            do {
                                try nestedFunc()
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            expect(dummy.invocations.first!.functionName).to(equal("nestedFunc()"))
                        }
                        
                        it("captures the method ID and arguments for the invocation") {
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                            }
                            
                            // then
                            expect(dummy.invocations).to(haveCount(1))
                            let invocation = dummy.invocations.first!
                            expect(invocation.methodID) == MockDummy.Methods.myFunc.rawValue
                            expect(invocation.args).to(haveCount(4))
                            expect(invocation.args[0] as! String?).to(equal("aaa"))
                            expect(invocation.args[1] as! Int?).to(equal(42))
                            expect(invocation.args[2]).to(beNil())
                            expect(invocation.args[3] as! Double?).to(equal(3.14))
                        }
                        
                        it("rethrows the error") {
                            // given
                            var didThrow = false
                            
                            // when
                            do {
                                _ = try dummy.registerThrowingInvocation(for: .myFunc, args: "aaa", 42, nil, 3.14) { _ in
                                    throw DummyError.somethingBadHappened
                                }
                            }
                            catch {
                                didThrow = true
                            }
                            
                            // then
                            expect(didThrow).to(beTrue())
                        }
                        
                    }

                }
            }
        }
        
        describe("resetting the mock") {
            
            it("clears the invocations array") {
                // given
                dummy.registerInvocation(for: .myFunc)
                expect(dummy.invocations).to(haveCount(1))
                
                // when
                dummy.resetMock()
                
                // then
                expect(dummy.invocations).to(beEmpty())
            }
            
        }
        
        describe("setting stubs") {
            
            context("returning a direct T value") {
                beforeEach {
                    dummy.stub(.myFunc, andReturn: 42)
                }
                
                it("overrides the default return value") {
                    // when
                    let result = dummy.registerInvocation(for: .myFunc, andReturn: 0)
                    
                    // then
                    expect(result) == 42
                }
                
                it("overwrites the previously set stub") {
                    // when
                    dummy.stub(.myFunc, andReturn: 43)
                    
                    // then
                    let result = dummy.registerInvocation(for: .myFunc, andReturn: 0)
                    expect(result) == 43
                }
            }

            context("returning a direct T? value") {
                beforeEach {
                    dummy.stub(.myFunc, andReturn: 42 as Int?)
                }
                
                it("overrides the default return value") {
                    // when
                    let result = dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                    
                    // then
                    expect(result) == 42
                }
                
                it("overwrites the previously set stub") {
                    // when
                    dummy.stub(.myFunc, andReturn: 43 as Int?)
                    
                    // then
                    let result = dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                    expect(result) == 43
                }
            }
            
            context("returning a T value with closure") {
                
                context("the closure returns normally") {

                    beforeEach {
                        dummy.stub(.myFunc) { _ in 42 }
                    }
                    
                    it("overrides the default return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: 0)
                        
                        // then
                        expect(result) == 42
                    }
                    
                    it("overwrites the previously set stub") {
                        // when
                        dummy.stub(.myFunc) { _ in 43 }
                        
                        // then
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: 0)
                        expect(result) == 43
                    }

                }
                
                context("the closure throws") {

                    beforeEach {
                        dummy.stub(.myFunc) { _ -> Int in
                            throw DummyError.somethingBadHappened
                        }
                    }
                    
                    it("overrides the default return value") {
                        // given
                        var didThrow = false
                        
                        // when
                        do {
                            _ = try dummy.registerThrowingInvocation(for: .myFunc, andReturn: 0)
                        }
                        catch {
                            didThrow = true
                        }
                        
                        // then
                        expect(didThrow).to(beTrue())
                    }
                    
                    it("overwrites the previously set stub") {
                        // when
                        dummy.stub(.myFunc) { _ in 43 }
                        
                        // then
                        do {
                            let result = try dummy.registerThrowingInvocation(for: .myFunc, andReturn: 0)
                            expect(result) == 43
                        }
                        catch {
                        }
                    }

                }

            }

            context("returning a T? value with closure") {

                context("the closure returns normally") {
                    
                    beforeEach {
                        dummy.stub(.myFunc) { _ in 42 as Int? }
                    }
                    
                    it("overrides the default return value") {
                        // when
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                        
                        // then
                        expect(result) == 42
                    }
                    
                    it("overwrites the previously set stub") {
                        // when
                        dummy.stub(.myFunc) { _ in 43 as Int? }
                        
                        // then
                        let result = dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                        expect(result) == 43
                    }
                    
                }
                
                context("the closure throws") {
                    
                    beforeEach {
                        dummy.stub(.myFunc) { _ -> Int? in
                            throw DummyError.somethingBadHappened
                        }
                    }
                    
                    it("overrides the default return value") {
                        // given
                        var didThrow = false
                        
                        // when
                        do {
                            _ = try dummy.registerThrowingInvocation(for: .myFunc, andReturn: 0 as Int?)
                        }
                        catch {
                            didThrow = true
                        }
                        
                        // then
                        expect(didThrow).to(beTrue())
                    }
                    
                    it("overwrites the previously set stub") {
                        // when
                        dummy.stub(.myFunc) { _ in 43 as Int? }
                        
                        // then
                        do {
                            let result = try dummy.registerThrowingInvocation(for: .myFunc, andReturn: 0 as Int?)
                            expect(result) == 43
                        }
                        catch {
                        }
                    }
                    
                }

            }
            
            context("returning direct T values multiple times") {
                beforeEach {
                    dummy.stub(.myFunc, andReturn: 42, times: 1, afterwardsReturn: 43)
                }

                it("overrides the default return value for all invocations") {
                    // when
                    let results = [
                        dummy.registerInvocation(for: .myFunc, andReturn: 0),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0)
                    ]
                    
                    // then
                    expect(results[0]) == 42
                    expect(results[1]) == 43
                    expect(results[2]) == 43
                }
                
                it("overwrites the previously set stub") {
                    // when
                    dummy.stub(.myFunc, andReturn: 420, times: 1, afterwardsReturn: 430)
                    
                    // then
                    let results = [
                        dummy.registerInvocation(for: .myFunc, andReturn: 0),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0)
                    ]
                    
                    expect(results[0]) == 420
                    expect(results[1]) == 430
                    expect(results[2]) == 430
                }

            }

            context("returning direct T? values multiple times") {
                beforeEach {
                    dummy.stub(.myFunc, andReturn: 42 as Int?, times: 1, afterwardsReturn: 43 as Int?)
                }

                it("overrides the default return value for all invocations") {
                    // when
                    let results = [
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                    ]
                    
                    // then
                    expect(results[0]) == 42
                    expect(results[1]) == 43
                    expect(results[2]) == 43
                }
                
                it("overwrites the previously set stub") {
                    // when
                    dummy.stub(.myFunc, andReturn: 420 as Int?, times: 1, afterwardsReturn: 430 as Int?)
                    
                    // then
                    let results = [
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?),
                        dummy.registerInvocation(for: .myFunc, andReturn: 0 as Int?)
                    ]
                    
                    expect(results[0]) == 420
                    expect(results[1]) == 430
                    expect(results[2]) == 430
                }

            }

        }
        
        describe("removing stubs") {
            
            beforeEach {
                dummy.stub(.myFunc, andReturn: 42)
                dummy.stub(.myOtherFunc, andReturn: 3.14)
            }
            
            it("restores the default return value for the given mock method") {
                // when
                dummy.unstub(.myFunc)
                
                // then
                let result = dummy.registerInvocation(for: .myFunc, andReturn: 0)
                expect(result) == 0
            }
            
            it("doesn't affect the behavior of other methods") {
                // when
                dummy.unstub(.myFunc)
                
                // then
                let result = dummy.registerInvocation(for: .myOtherFunc, andReturn: 0.0)
                expect(result) == 3.14
            }
            
        }
    }
}
