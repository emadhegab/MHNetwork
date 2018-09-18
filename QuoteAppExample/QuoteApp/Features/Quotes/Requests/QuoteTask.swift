//
//  QuoteTask.swift
//  QuoteApp
//
//  Created by Mohamed Emad Abdalla Hegab on 17.07.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation


class QuoteTask <T: Codable>: MHNetwork.Operation {

    var request: Request {
        return QuoteRequest.getRandomQuote
    }

    func exeute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (NetworkErrors) -> Void) {

        do {
            try dispatcher.execute(request: self.request, completion: { (response) in
                switch response {
                case .data(let data):
                    do {
                        let decoder = JSONDecoder()
                        //                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        //                        uncomment this in case you have some json properties in Snake Case and you just want to decode it to camel Case... workes only for swift 4.1
                        let object = try decoder.decode(T.self, from: data)
                        completed(object)
                    } catch let error {
                        onError(NetworkErrors.parsingError(error.localizedDescription))
                    }
                    break
                case .error(_, let networkError):
                    guard let error = networkError else { break }
                    onError(error)
                    break
                default: break

                }
            }, onError: onError)
        } catch {
            guard let safeError = error as? NetworkErrors else { return }
            onError(safeError)
        }
    }

}
