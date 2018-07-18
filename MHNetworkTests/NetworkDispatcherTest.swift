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
        return "quotes/random/"
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

    var dataType: DataType {
        return .data
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
    var dataType: DataType {
        return .data
    }

}

private class MockQuoteTask<T: Codable>: Operations {
    var body: Bool = false

    var request: Request {
        return MockQuoteRequest.getRandomQuote
    }

    func exeute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (NetworkErrors) -> Void) {

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
                        onError(NetworkErrors.parsingError(error.localizedDescription))
                    }
                    break
                case .error(_, let networkError):
                    guard let error = networkError else { break }
                    onError(error)
                    break
                default: break

                }
            }, onError: onError)
        } catch {
            guard let safeError = error as? NetworkErrors else { return }
            onError(safeError)
        }
    }
}


private class MockBadTask<T: Codable>: Operations {

    var body: Bool = false
    var request: Request {
        return MockBadRequest(body: body)
    }

    func exeute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (NetworkErrors) -> Void) {
        do {

            try dispatcher.execute(request: request, completion: { (response) in
                switch response {

                case .data(let data):
                    do {
                        let decoder = JSONDecoder()
                        let t = try decoder.decode(T.self, from: data)
                        completed(t)
                    } catch let error {
                        onError(NetworkErrors.parsingError(error.localizedDescription))
                    }
                case .error(_, let networkError):
                    guard let error = networkError else { break }
                    onError(error)
                default: break

                }
            }, onError: { (error) in
                onError(error)
            })

        } catch {
            if let error = error.convertToNetworkApplicationError() {
                onError(error)
            }
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
        env = Environment(host: "BADURL")
        env.headers = ["Authorization" : "1234"]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        networkDispatcher = NetworkDispatcher(environment: env, session: session)
        let expectation = self.expectation(description: "network failed to connect")
        mockTask.exeute(in: networkDispatcher, completed: { _ in
            XCTFail("Should not succeed")
        }) { (error) in
            expectation.fulfill()
            XCTAssertNotNil(error)
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testBadRequest() {
        let expectation = self.expectation(description: "network failed to connect")
        mockBadTask.exeute(in: networkDispatcher, completed: { _ in
            XCTFail("Should not succeed")
        }) { (error) in
            expectation.fulfill()
            XCTAssertNotNil(error)
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testNetworkConnectability() {
        let expectation = self.expectation(description: "network connected")

        let networkDispatcher = NetworkDispatcher(environment: env, session: URLSession(configuration: .default))
        let quoteTask = MockQuoteTask<MockQuote>()
        quoteTask.exeute(in: networkDispatcher, completed: { (quote) in
            DispatchQueue.main.async {
                XCTAssertNotNil(quote)
                expectation.fulfill()
            }
        }) { (error) in
            XCTFail()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testNetworkDispacherWithURLQuery() {
        let expectation = self.expectation(description: "network Dispatcher")
        mockTask.body = false
        mockTask.exeute(in: networkDispatcher, completed: { _ in

            expectation.fulfill()
        }, onError: { error in

            XCTFail("Request shouldn't fail")
        })

        waitForExpectations(timeout: timeout, handler: nil)
    }
    
}

