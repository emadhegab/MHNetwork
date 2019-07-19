//
//  PostPresenter.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class PostPresenter: PostPresenterProtocol {

    weak private var view: PostViewProtocol?
    var interactor: PostInteractorProtocol?

    init(interface: PostViewProtocol, interactor: PostInteractorProtocol?) {
        self.view = interface
        self.interactor = interactor
    }

    func getPosts(userId: String) {
        interactor?.getPosts(userId: userId, onCompletion: { (posts) in
            DispatchQueue.main.async {  [weak self]  in
                self?.view?.reloadData(posts: posts)
            }
        }, onError: { (error) in
            print(error)
        })
    }
    
}
