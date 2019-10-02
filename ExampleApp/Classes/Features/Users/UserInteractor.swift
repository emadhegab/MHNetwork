//
//  UserInteractor.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

class UserInteractor: UserInteractorProtocol {

    weak var presenter: UserPresenterProtocol?
    func getUsers(onCompletion: @escaping ([User]) -> Void, onError: @escaping (NetworkError) -> Void) {
        let dispatcher = Container.shared.createNetworkDispatcher()
        let getUsersTask = GetUsersTasks<[User]>()


        getUsersTask.execute(in: dispatcher) { (result) in
            switch result {
            case .success(let users):
                onCompletion(users)
            case .failure(let error):
                onError(error)
            }
        }

    }
}
