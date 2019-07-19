//
//  PostProtocols.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

//MARK: Presenter -
protocol PostPresenterProtocol: class {
    func getPosts(userId: String)
}

//MARK: Interactor -
protocol PostInteractorProtocol: class {

    var presenter: PostPresenterProtocol?  { get set }
    func getPosts(userId: String, onCompletion:  @escaping ([Post]) -> Void, onError: @escaping  (ErrorItem) -> Void)
}

//MARK: View -
protocol PostViewProtocol: class {

    var presenter: PostPresenterProtocol?  { get set }
    func reloadData(posts: [Post])
}
