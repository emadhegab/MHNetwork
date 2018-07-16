//
//  TestData.swift
//  MHNetworkTests
//
//  Created by Nestor Adrian Gomez Elfi on 19.06.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation
@testable import MHNetwork

let sampleURL = "https://talaikis.com/api"

struct TestData {
    static let succeededHttpResponse = HTTPURLResponse(url: URL(string: sampleURL)!,
                                                       statusCode: 200,
                                                       httpVersion: "1.0",
                                                       headerFields: nil)
    static let dummyUserJSON = """
                                    {
                                        "access_token": "AN_ACCESS_TOKEN"
                                    }
                                """
}

