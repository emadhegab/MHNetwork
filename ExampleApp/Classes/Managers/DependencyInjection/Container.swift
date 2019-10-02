//
//  Container.swift
//  Dazzler
//
//  Created by Mohamed Emad Abdalla Hegab on 03.09.18.
//  Copyright © 2018 Dazzler. All rights reserved.
//

import Foundation

class Container {

    static let shared = Container()

    func createBaseRouter() -> BaseRouter {
        return DefaultBaseRouter()
    }

    func createNetworkDispatcher() -> NetworkDispatcher {

        let  defaultHeaders = ["Content-Type": "application/json",
                               "Accept": "application/json"]
        let url: String = "https://jsonplaceholder.typicode.com"

        var environment = Environment(host: url)
        // should create headers here

        environment.headers = defaultHeaders
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let dispatcher =  NetworkDispatcher(environment: environment, session: session)
        return dispatcher
    }

}
