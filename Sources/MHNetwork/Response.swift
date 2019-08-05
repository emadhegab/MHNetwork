//
//  Response.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 31.01.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation
public typealias ErrorItem = (code: HTTPStatusCodes?, error: Error?, data: Data?)
public enum Response {

    case data(_: Data)
    case error(error: ErrorItem)

    public init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard let serverResponse = response.r else {
            self = Response.handleNetworkError(status: 500, error: nil, data: nil)
            return
        }

        switch serverResponse.statusCode {
        case 100 ... 399: //Success
            guard let responseData = response.data else {
                self = Response.handleNetworkError(status: serverResponse.statusCode, error: nil, data: nil)
                return
            }
            self = Response.data(responseData)
        case 400 ... 499: //Client error
            self = Response.handleNetworkError(status: serverResponse.statusCode, error: response.error, data: response.data)
        case 500 ... 599: //Server error
            self = Response.handleNetworkError(status: serverResponse.statusCode, error: response.error, data: response.data)
        default: // unknown error
            self = Response.handleNetworkError(status: serverResponse.statusCode, error: response.error, data: response.data)
        }
    }

    private static func handleNetworkError(status: Int, error: Error?, data: Data?) -> Response {
        // Handle the error and convert it to application friendly error
        return .error(error: (code: HTTPStatusCodes(rawValue: status), error: error, data: data))

    } 
}


