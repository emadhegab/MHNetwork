//
//  PostRequests.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

enum PostRequests: Request {
    case getPosts(userId: String)
    
    var path: String {
        return "posts"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: RequestParams {
        switch self {
        case .getPosts(let userId):
            return .url(["usersId": userId])
        }
    }
    
    var headers: [String : Any]? {
        return nil
    }
    
    
}
