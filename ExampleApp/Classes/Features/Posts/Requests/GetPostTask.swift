//
//  GetPostTask.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//
import UIKit

class GetPostsTasks<T: Codable>: Operations {
    
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var request: Request {
        return PostRequests.getPosts(userId: self.userId)
    }
    
    func execute(in dispatcher: Dispatcher, completed: @escaping (Result<T, NetworkError>) -> Void) {
        
        do {
            try dispatcher.execute(request: self.request, completion: { result in
                 switch result {
                               case .success(let response):
                                   switch response {
                                       case .data(let data):
                                           do {
                                               let decoder = JSONDecoder()
                                               let object = try decoder.decode(T.self, from: data)
                                               completed(.success(object))
                                           } catch let error {
                                               print("error Parsing with Error: \(error.localizedDescription)")
                                           }
                                           break
                                       case .error(let error):
                                           completed(.failure(error))
                                           break
                                       }
                               case .failure(let error):
                                   completed(.failure(error))
                               }
            })
        } catch {
            print("error")
        }
    }
}
