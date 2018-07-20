//
//  ResponseTest.swift
//  MHNetworkTests
//
//  Created by Nestor Adrian Gomez Elfi on 19.06.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import XCTest
import Nimble
@testable import MHNetwork

struct RequestMock: Request {
    let path: String = sampleURL
    let method: HTTPMethod = .get
    var parameters: RequestParams = .url(nil)
    var headers: [String : Any]? = nil
}

class ResponseTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//
//    func testEmptyResponseWithSuccessStatus() {
//        let response = Response((r: TestData.succeededHttpResponse, data: nil, error: nil), for: RequestMock())
//        switch response {
//        case .error(let statusCode, let error, let data):
//            expect(statusCode).to(equal(200))
//            expect(error).to(equal(NetworkErrors.noData))
//        default:
//            XCTFail("Response type should be of .error instead of \(type(of: response))")
//        }
//    }
    func testFailWithURLWithCanceledError() {
        let bodyContent = "test-body-data"
        let error = NSError(domain: NSURLErrorDomain.description, code: URLError.cancelled.rawValue,
                            userInfo: [NSLocalizedDescriptionKey : "Cancelled"])
        let response = Response((r: TestData.failedHttpResponse,
                                 data: bodyContent.data(using: .utf8),
                                 error: error),
                                for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(500))
            expect(data).to(equal(bodyContent.data(using: .utf8)))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }
    func testFailWithURLWithNoCodeError() {
        let bodyContent = "test-body-data"
        let error = NSError(domain: NSURLErrorDomain.description, code: 0,
                            userInfo: [NSLocalizedDescriptionKey : "Object does not exist"])
        let response = Response((r: TestData.failedHttpResponse,
                                 data: bodyContent.data(using: .utf8),
                                 error: error),
                                for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let _):
            expect(statusCode).to(equal(500))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

    func testFailWithURLError() {
        let bodyContent = "test-body-data"
        let error = NSError(domain: NSURLErrorDomain.description, code: URLError.timedOut.rawValue,
                            userInfo: [NSLocalizedDescriptionKey : "Object timed out"])
        let response = Response((r: TestData.failedHttpResponse,
                                 data: bodyContent.data(using: .utf8),
                                 error: error),
                                for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(500))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

    func testFailWithError() {
        let bodyContent = "test-body-data"
        let error = NSError(domain: "", code: 0,
                            userInfo: [NSLocalizedDescriptionKey : "Object does not exist"])
        let response = Response((r: TestData.failedHttpResponse,
                                 data: bodyContent.data(using: .utf8),
                                 error: error),
                                for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(500))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

    func testUnspecifiedResponseError() {
        let response = Response((r: TestData.unspecifiedHttpResponse, data: nil, error: nil), for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(0))

        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

    func testFailedResponseUnAuthorized() {
        let bodyContent = "test-body-data"
        let response = Response((r: TestData.unAuthorizedHttpResponse, data: bodyContent.data(using: .utf8), error: nil), for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(401))
            expect(data).to(equal(bodyContent.data(using: .utf8)))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

    func testFailedResponse() {
        let bodyContent = "test-body-data"
        let response = Response((r: TestData.failedHttpResponse, data: bodyContent.data(using: .utf8), error: nil), for: RequestMock())
        switch response {
        case .error(let statusCode, let error, let data):
            expect(statusCode).to(equal(500))
            expect(data).to(equal(bodyContent.data(using: .utf8)))
        default:
            XCTFail("Response type should be of .error instead of \(type(of: response))")
        }
    }

//    func testEmptyURLResponseFailure() {
//        let bodyContent = "test-body-data"
//        let response = Response((r: nil, data: bodyContent.data(using: .utf8), error: nil), for: RequestMock())
//        switch response {
//        case .error(let statusCode, let error, let data):
//            expect(statusCode).to(equal(500))
//
//        default:
//            XCTFail("Response type should be of .error instead of \(type(of: response))")
//        }
//    }

    func testSucceededResponse() {
        let bodyContent = "test-body-data"
        let response = Response(
            (r: TestData.succeededHttpResponse,
             data: bodyContent.data(using: .utf8),
             error: nil),
            for: RequestMock())
        switch response {
        case .data(let bodyData):
            let bodyString = String(data: bodyData, encoding: .utf8)!
            XCTAssertEqual(bodyContent,
                           bodyString,
                           "The request body content should be \(bodyContent) instead of \(bodyString)")
        default:
            XCTFail("Response type should be of .data instead of \(type(of: response))")
        }
    }
}




