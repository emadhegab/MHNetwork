//
//  UserPresenter.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class UserPresenter: UserPresenterProtocol {
    

    weak private var view: UserViewProtocol?
    var interactor: UserInteractorProtocol?

    init(interface: UserViewProtocol, interactor: UserInteractorProtocol?) {
        self.view = interface
        self.interactor = interactor
    }

    func getUsers() {
        interactor?.getUsers(onCompletion: {(users) in
            DispatchQueue.main.async {  [weak self]  in
                self?.view?.reloadData(users: users)
            }
            
        }, onError: { (error) in
            print(error)
        })
    }
}
