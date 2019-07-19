//
//  Merchant_PlatformTests.swift
//  MHNetworkTests
//
//  Created by Mohamed Emad Abdalla Hegab on 06.02.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import XCTest

@testable import MHNetwork

let timeout: TimeInterval = 10

private enum MockQuoteRequest: Request {


    case getRandomQuote

    var path: String {
        return "users"
    }

    var method: HTTPMethod {
        switch self {
        case .getRandomQuote:
            return .get
        }
    }

    var parameters: RequestParams {
        return .url(nil)
    }

    var headers: [String : Any]? {
        return ["Authorization": "xyz"]
    }
}

private class MockBadRequest: Request {
    var body: Bool = false
    init(body: Bool) {
        self.body = body
    }
    var path: String {
        return "posts/10"
    }
    var method: HTTPMethod {
        return .get
    }
    var parameters: RequestParams {
        //params should be strings
        if body {
            return .body(["key": 1])
        } else {
            return .url(["key": 2])
        }

    }
    var headers: [String: Any]? {
        return ["Content-Type":"application/json"]
    }
}

private class MockQuoteTask<T: Codable>: Operations {
    var body: Bool = false

    var request: Request {
        return MockQuoteRequest.getRandomQuote
    }

    func execute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (ErrorItem) -> Void) {

        do {
            try dispatcher.execute(request: self.request, completion: { (response) in
                switch response {
                case .data(let data):
                    do {
                        let decoder = JSONDecoder()
                        //                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        //                        uncomment this in case you have some json properties in Snake Case and you just want to decode it to camel Case... workes only for swift 4.1
                        let object = try decoder.decode(T.self, from: data)
                        completed(object)
                    } catch let error {
                        onError((nil, error, nil))
                    }
                    break
                case .error(let error):
                    onError(error)
                    break
                }
            }, onError: onError)
        } catch {
            onError((nil, error, nil))
        }
    }
}


private class MockBadTask<T: Codable>: Operations {

    var body: Bool = false
    var request: Request {
        return MockBadRequest(body: body)
    }

    func execute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (ErrorItem) -> Void) {
        do {


            
            try dispatcher.execute(request: request, completion: { (response) in
                switch response {

                case .data(let data):
                    do {
                        let decoder = JSONDecoder()
                        let t = try decoder.decode(T.self, from: data)
                        completed(t)
                    } catch let error {
                        onError((nil, error, nil))
                    }
                case .error(let error):
                    onError(error)
                    break
                }
            }, onError: { (error) in
                onError(error)
            })

        } catch {
            onError((nil, error, nil))
        }
    }
}

private class MockUser: Codable {
    let access_token: String
}

struct MockQuote: Codable {
    let quote: String
    let author: String
}


class NetworkDispatcherTests: XCTestCase {

    var networkDispatcher: NetworkDispatcher!
    fileprivate let mockTask = MockQuoteTask<MockQuote>()
    fileprivate let mockBadTask = MockBadTask<MockUser>()
    var env: Environment!
 

    override func setUp() {
        super.setUp()
        env = Environment(host: sampleURL)
        env.headers = ["Authorization" : "1234"]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        networkDispatcher = NetworkDispatcher(environment: env, session: session)
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkDispatcher = nil
        super.tearDown()
    }

    func testBadURL() {
         let exp = expectation(description: "fail")
        env = Environment(host: "BADURL")
        env.headers = ["Authorization" : "1234"]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        networkDispatcher = NetworkDispatcher(environment: env, session: session)
        var checker = false
        mockTask.execute(in: networkDispatcher, completed: { _ in
            XCTFail("Should not succeed")
        }) { (error) in
            checker = true
            exp.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(checker, true)

    }

    func testBadRequest() {
        let exp = expectation(description: "fail")
        var checker = false
        mockBadTask.execute(in: networkDispatcher, completed: { _ in
            XCTFail("Should not succeed")
        }) { (error) in
            checker = true
            exp.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
        XCTAssertEqual(checker, true)
    }

}

