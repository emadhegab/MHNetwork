//
//  UserInteractor.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

class UserInteractor: UserInteractorProtocol {

    weak var presenter: UserPresenterProtocol?
    func getUsers(onCompletion: @escaping ([User]) -> Void, onError: @escaping (ErrorItem) -> Void) {
        let dispatcher = Container.shared.createNetworkDispatcher()
        let getUsersTask = GetUsersTasks<[User]>()
        
        getUsersTask.execute(in: dispatcher, completed: { (response) in
            onCompletion(response)
        }) { (error) in
            onError(error)
        }
    }
}
