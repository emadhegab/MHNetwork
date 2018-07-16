//
//  ApplicationError.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 31.01.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum NetworkErrors: Error, Equatable {

    case badInput
    case noData
    case unauthorized
    case noInternet
    case serverReturnedError(ServerErrorResponse)
    case parsingError(String)
}

public func == (lhs: NetworkErrors, rhs: NetworkErrors) -> Bool {
    switch (lhs, rhs) {
    case (.noData, .noData),
         (.noInternet, .noInternet),
         (.badInput, .badInput),
         (.unauthorized, .unauthorized):
        return true
    case (.serverReturnedError(let lhsResp), .serverReturnedError(let rhsResp)):
        return lhsResp == rhsResp
    case (.parsingError(let rhsString), .parsingError(let lhsString)):
        return rhsString == lhsString
    default:
        return false
    }
}

public struct ServerErrorResponse: Equatable, CustomStringConvertible {
    let code: String?
    let message: String?
    let detail: String?

    public var description: String {
            return message ?? "Unresolved Error"
    }
}

public func == (lhs: ServerErrorResponse, rhs: ServerErrorResponse) -> Bool {
    return lhs.code == rhs.code && lhs.message == rhs.message && lhs.detail == rhs.detail
}

extension ServerErrorResponse {
    init(json: JSON) {
        self.init(code: json["code"].stringValue, message: json["message"].stringValue, detail: json["detail"].stringValue)
    }
}

extension Error {

    func convertToNetworkApplicationError() -> NetworkErrors? {
        guard let urlError = self as? URLError else {

            if let underlyingError = (self as NSError).userInfo[NSUnderlyingErrorKey] as? Error {
                return underlyingError.convertToNetworkApplicationError()
            }
            return .noData
        }

        // not initialized here to make any code path initialize it and compiler will confirm this for us.
        let applicationError: NetworkErrors

        switch urlError {
        case
        URLError.notConnectedToInternet,
        URLError.cannotFindHost,
        URLError.cannotConnectToHost,
        URLError.networkConnectionLost,
        URLError.timedOut:

            applicationError = .noInternet
        case URLError.cancelled:
            return nil // ignore the cancel error

        default:
            applicationError = .noData
        }

        return applicationError
    }
}
