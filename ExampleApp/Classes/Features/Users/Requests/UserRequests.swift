//
//  UserRequests.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

enum UserRequests: Request {
    case getUsers
    
    var path: String {
        return "users"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: RequestParams {
        return .url(nil)
    }
    
    var headers: [String : Any]? {
        return nil
    }
    
    
}
