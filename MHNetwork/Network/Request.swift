//
//  Request.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 31.01.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

/// Define the type of data we expect as response
///

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public enum HTTPMethod: String {
    case post           = "POST"
    case put            = "PUT"
    case get            = "GET"
    case delete         = "DELETE"
    case patch          = "PATCH"
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
}
