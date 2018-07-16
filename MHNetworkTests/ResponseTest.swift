//
//  ResponseTest.swift
//  MHNetworkTests
//
//  Created by Nestor Adrian Gomez Elfi on 19.06.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import XCTest
@testable import MHNetwork

struct RequestMock: Request {
    let path: String = sampleURL
    let method: HTTPMethod = .get
    var parameters: RequestParams = .url(nil)
    var headers: [String : Any]? = nil
    var dataType: DataType = .data

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




