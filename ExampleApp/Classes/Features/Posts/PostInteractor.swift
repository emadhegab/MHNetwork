//
//  PostInteractor.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

class PostInteractor: PostInteractorProtocol {

    weak var presenter: PostPresenterProtocol?
    func getPosts(userId: String, onCompletion: @escaping ([Post]) -> Void, onError: @escaping (NetworkError) -> Void) {
        let dispatcher = Container.shared.createNetworkDispatcher()
        let getPostsTask = GetPostsTasks<[Post]>(userId: userId)

        getPostsTask.execute(in: dispatcher) { (result) in
            switch result {
            case .success(let posts):
                onCompletion(posts)
            case .failure(let error):
                onError(error)
            }
        }
    }
}
