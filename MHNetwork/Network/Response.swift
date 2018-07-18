//
//  Response.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 31.01.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum Response {

    case json(_: JSON)
    case data(_: Data)
    case error(_: Int?, _: NetworkErrors?)

    public init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {

        guard let serverResponse = response.r else {
            self = .error(500, NetworkErrors.noData)
            return
        }

        switch serverResponse.statusCode {
        case 100 ... 399: //Success
            guard let responseData = response.data else {
                self = .error(serverResponse.statusCode, NetworkErrors.noData)
                return
            }
            self = Response.determineData(by: request.dataType, data: responseData)
        case 400 ... 499: //Client error
            self = Response.handleNetworkError(status: serverResponse.statusCode, error: response.error, data: response.data)
        case 500 ... 599: //Server error
            self = Response.handleNetworkError(status: serverResponse.statusCode, error: response.error, data: response.data)
        default: // unknown error
            self = .error(serverResponse.statusCode,
                          NetworkErrors.serverReturnedError(ServerErrorResponse(code: "\(serverResponse.statusCode)",
                                                                                message: Response.defaultGeneralErrorMessage,
                                                                                detail: nil)))
        }
    }

    private static func determineData(by type: DataType, data: Data) -> Response {
        switch type {
        case .data:
            return .data(data)
        case .json:
            do {
                let jsonData = try JSON(data: data)
                return .json(jsonData)
            } catch let error {
                print("Malformed JSON error: \(error.localizedDescription)")
                return .error(nil, NetworkErrors.parsingError(error.localizedDescription))
            }
        }
    }

    private static func handleNetworkError(status: Int, error: Error?, data: Data?) -> Response {
        // Handle the error and convert it to application friendly error

            if status == 401 {
                return .error(status, NetworkErrors.unauthorized)
            } else if  let error = error   ,
                let applicationError = error.convertToNetworkApplicationError() {
                return .error(status, applicationError)
            } else if let data = data {
                return .error(status, Response.parseServerError(status, data: data))
            } else {
                return .error(status, Response.genericError(status, message: nil))
            }
    }

    private static func parseServerError(_ status: Int, data: Data?) -> NetworkErrors {

        guard let data = data else {
            return Response.genericError(status, message: defaultGeneralErrorMessage)
        }

        if let errorsJson = try? JSON(data: data),
           let firstJsonError = errorsJson["errors"].array?.first {
            return .serverReturnedError(ServerErrorResponse(json: firstJsonError))
        } else if let errorMessage = try? JSON(data: data)["message"].string {
            return .serverReturnedError(ServerErrorResponse(code: "\(status)", message: errorMessage, detail: nil))
        } else {
            return Response.genericError(status, message: defaultGeneralErrorMessage)
        }
    }

    private static func genericError(_ status: Int, message: String?) -> NetworkErrors {
        return NetworkErrors.serverReturnedError(
                                ServerErrorResponse(code: "\(status)",
                                                    message: message ?? defaultGeneralErrorMessage,
                                                    detail: nil)
        )
    }

    //TODO: Localize these error messages
    private static let defaultGeneralErrorMessage = "General Server Error"
    private static let defaultNoInfoMessage = "No error info"
}
