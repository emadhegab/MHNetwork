//
//  GetUsersTasks.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import Foundation


class GetUsersTasks<T: Codable>: Operations {
    
    var request: Request {
        return UserRequests.getUsers
    }
    
    func execute(in dispatcher: Dispatcher, completed: @escaping (T) -> Void, onError: @escaping (ErrorItem) -> Void) {
        
        do {
            try dispatcher.execute(request: self.request, completion: { response in
                switch response {
                case .data(let data):
                    do {
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(T.self, from: data)
                        completed(object)
                    } catch let error {
                        print("error Parsing with Error: \(error.localizedDescription)")
                    }
                    break
                case .error(let error):
                    onError(error)
                    break
                }
            }, onError: onError)
        } catch {
            print("error")
        }
    }
}

