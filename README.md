# MHNetwork
Protocol Oriented Network Layer Aim to avoid having bloated singleton NetworkManager

[![Build Status](https://travis-ci.org/emadhegab/MHNetwork.svg?branch=master)](https://travis-ci.org/emadhegab/MHNetwork)
[![Coverage Status](https://codecov.io/gh/emadhegab/MHNetwork/branch/master/graphs/badge.svg)](https://codecov.io/gh/emadhegab/MHNetwork/branch/master)


 ## Philosophy
the main philosophy behind MHNetwork is to have a single responsibility. it makes it much easier to determine where is the problem located in your code if every class in your code have only one task and one task only to do.
so in the beginning..

#### install

```
$ pod install MHNetwork
```
or in your podfile
```
pod 'MHNetwork'
```

also you can use `Swift Package Manager`

#### usage

let's say you have movies API .. and you need to make a request call to get the movies list..

you will need to create two files for your feature
`MoviesRequests.swift` and `MoviesTasks.swift`

in the request it should be something like this

```

import Foundation
import MHNetwork

enum MoviesRequests: Request {
    case getMoviesList

    var path: String {
        return "movies/list/"
    }

    var method: HTTPMethod {
        switch self {
        case .getRandomQuote:
            return .get
        }
    }

    var parameters: RequestParams {
        return .url(["year" : "2018"])
        // can use .body(["year": "20018"]) if the api require body parameters
    }

    var headers: [String : Any]? {
        return ["Authorization": "xyz"]
    }
}
```

then add your task

```

class MovieTasks <T: Codable>: Operations {

    var request: Request {
        return MoviesRequests.getMoviesList
    }

    func execute(in dispatcher: Dispatcher, completed: @escaping (Result<T, NetworkError>) -> Void) {

        do {
            try dispatcher.execute(request: self.request, completion: { (result) in
               switch result {
                               case .success(let response):
                                   switch response {
                                       case .data(let data):
                                           do {

                        let decoder = JSONDecoder()
                        //                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        //                        uncomment this in case you have some json properties in Snake Case and you just want to decode it to camel Case... workes only for swift 4.1 or higher
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
          completed(.failure(.error(code: nil, error: error, data: nil)))
        }
    }
}

```

that's it you finished your basic setup for the request.. now you can call it from your code like that

```
func getMoviesList(onComplete: @escaping (Movie) -> Void, onError: @escaping (Error) -> Void) {
    let environment = Environment(host: "https://imdb.com/api")
    let networkDispatcher = NetworkDispatcher(environment: environment, session: URLSession(configuration: .default))
    let moviesTask = MoviesTasks<Movie>() // Movie Model should be codable
    moviesTask.execute(in: networkDispatcher) { (result) in
          switch result {
            case .success(let users):
                onCompletion(movies)
            case .failure(let error):
                onError(error)
            }
         })
}
```

that's it..
one last note.. when creating the instance of MoviesTask you noticed the comment that `Movie Model should be Codable` well.. it's not a must but my preferable way.. just suit yourself in the task itself and make it less restricted if you like but you'll need to handle the returned data in another way.


### TODO://
- [ ] need to support JSON return type without depending on any 3rd party
- [x] need to fix & clean the example test cases and code


### Contribute://
 fork / edit / and Pull request to Develop Branch... you know what to do ;)
