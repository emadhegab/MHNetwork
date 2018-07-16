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

private class MockRequest: Request {

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

        if body {
            return .body(["key": "value"])
        } else {
            return .url(["key": "value"])
        }

    }
    var headers: [String: Any]? {
        return ["Content-Type":"application/json"]
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

private class MockTask<T: Codable>: MHNetwork.Operation {
    var shouldFail = false
    var body: Bool = false
    var request: Request {
        return MockRequest(body: body)
    }

    func exeute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (NetworkErrors) -> Void) {
        do {
            if shouldFail {
                onError(NetworkErrors.serverReturnedError(ServerErrorResponse(code: "500",
                                                                              message: "Something wrong happened",
                                                                              detail: nil)))
            } else {
                do {
                    let decoder = JSONDecoder()
                    let user = try decoder.decode(T.self, from: TestData.dummyUserJSON.data(using: .utf8)!)
                    print(user)
                    completed(user)
                } catch {
                    print(error)
                }
            }
        }
    }
}

private class MockBadTask<T: Codable>: MHNetwork.Operation {

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

class NetworkManagerTests: XCTestCase {

    var networkDispatcher: NetworkDispatcher!
    fileprivate let mockTask = MockTask<MockUser>()
    fileprivate let mockBadTask = MockBadTask<MockUser>()

    var isReachable: Bool {
        return Reachability()?.isReachable ?? false
    }

    override func setUp() {
        super.setUp()
        var env = Environment()
        env.host = sampleURL
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

        if !isReachable {
             XCTFail("No Internet")
        } else {
            expectation.fulfill()
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
