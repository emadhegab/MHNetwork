//
//  UserProtocols.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

//MARK: Presenter -
protocol UserPresenterProtocol: class {
    func getUsers()
}

//MARK: Interactor -
protocol UserInteractorProtocol: class {
    
    var presenter: UserPresenterProtocol?  { get set }
    func getUsers(onCompletion:  @escaping ([User]) -> Void, onError: @escaping  (NetworkError) -> Void)
}

//MARK: View -
protocol UserViewProtocol: class {

    var presenter: UserPresenterProtocol?  { get set }
    func reloadData(users: [User])
}
