//
//  TestData.swift
//  MHNetworkTests
//
//  Created by Nestor Adrian Gomez Elfi on 19.06.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation
@testable import MHNetwork

let sampleURL = "http://localhost:8080"

struct TestData {
    static let succeededHttpResponse = HTTPURLResponse(url: URL(string: sampleURL)!,
                                                       statusCode: 200,
                                                       httpVersion: "1.0",
                                                       headerFields: nil)
    static let failedHttpResponse = HTTPURLResponse(url: URL(string: sampleURL)!,
                                                    statusCode: 500,
                                                    httpVersion: "1.0",
                                                    headerFields: nil)
    static let unAuthorizedHttpResponse = HTTPURLResponse(url: URL(string: sampleURL)!,
                                                    statusCode: 401,
                                                    httpVersion: "1.0",
                                                    headerFields: nil)

    static let unspecifiedHttpResponse = HTTPURLResponse(url: URL(string: sampleURL)!,
                                                          statusCode: 0,
                                                          httpVersion: "1.0",
                                                          headerFields: nil)
    static let dummyUserJSON = """
                                    {
                                        "access_token": "AN_ACCESS_TOKEN"
                                    }
                                """
}

