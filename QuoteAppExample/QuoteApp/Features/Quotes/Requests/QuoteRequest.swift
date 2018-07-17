//
//  QuoteRequest.swift
//  QuoteApp
//
//  Created by Mohamed Emad Abdalla Hegab on 17.07.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//
//

import Foundation
@_exported import MHNetwork

enum QuoteRequest: Request {
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
