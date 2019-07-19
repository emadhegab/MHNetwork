//
//  PostInteractor.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

class PostInteractor: PostInteractorProtocol {

    weak var presenter: PostPresenterProtocol?
    func getPosts(userId: String, onCompletion: @escaping ([Post]) -> Void, onError: @escaping (ErrorItem) -> Void) {
        let dispatcher = Container.shared.createNetworkDispatcher()
        let getPostsTask = GetPostsTasks<[Post]>(userId: userId)
        
        getPostsTask.execute(in: dispatcher, completed: { (response) in
            onCompletion(response)
        }) { (error) in
            onError(error)
        }
    }
}
