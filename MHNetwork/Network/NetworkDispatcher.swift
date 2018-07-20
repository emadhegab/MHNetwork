//
//  NetworkDispatcher.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 31.01.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//


public class NetworkDispatcher: Dispatcher {
    private var environment: Environment
    private var session: URLSession

    required public init(environment: Environment,
                  session: URLSession) {
        self.environment = environment
        self.session = session
    }

    public func execute(request: Request, completion: @escaping (Response) -> Void,
                        onError: @escaping (Error) -> Void) throws {

        try self.prepareURLRequest(for: request, onComplete: { [weak self] (rq) in
            guard let `self` = self else { return }
            let dataTask = self.session.dataTask(with: rq, completionHandler: { (data, urlResponse, error) in
                let response = Response( (urlResponse as? HTTPURLResponse, data, error), for: request)
                completion(response)
            })
            dataTask.resume()
        }, onError: {error in
            onError(error)
        })

    }

    private func prepareURLRequest(for request: Request,
                                   onComplete: @escaping (URLRequest) -> Void,
                                   onError: @escaping (Error) -> Void) throws {
        // Compose the url
        let fullUrl = "\(environment.host)/\(request.path)"
        var urlRequest: URLRequest!
        // Working with parameters
        switch request.parameters {
        case .body(let params):
            // Parameters are part of the body
            if let url = URL(string: fullUrl) {
                urlRequest = URLRequest(url: url)
                let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .init(rawValue: 0))
                urlRequest.httpBody = jsonData
                createHeadersInRequest(urlRequest, request, onComplete: { (urlRequest) in
                    onComplete(urlRequest)
                })

            }
        case .url(let params):
            // Parameters are part of the url

            let queryParams = params?.map({ (element) -> URLQueryItem in
                return URLQueryItem(name: element.key, value: element.value as? String)
            })
            guard var components = URLComponents(string: fullUrl), let url = URL(string: fullUrl) else {
                onError(NetworkError.runTimeError("Bad Input"))
                return
            }
            components.queryItems = queryParams
            // Replace + and : to URLEncode the dates in the paramters url.
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: ":", with: "%3A")
            urlRequest = URLRequest(url: url)
            urlRequest.url = components.url
            createHeadersInRequest(urlRequest, request, onComplete: { (urlRequest) in
                onComplete(urlRequest)
            })
        }
    }

    fileprivate func createHeadersInRequest(_ urlRequest: URLRequest,
                                            _ request: Request,
                                            onComplete: @escaping (URLRequest) -> Void) {
        // Add headers from enviornment and request
        var urlRequest = urlRequest
        self.environment.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        // Setup HTTP method
        urlRequest.httpMethod = request.method.rawValue
        onComplete(urlRequest)

    }


}
