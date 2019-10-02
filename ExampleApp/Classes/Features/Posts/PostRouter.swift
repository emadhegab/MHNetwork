//
//  PostRouter.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class PostRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule(userId: String) -> UIViewController {
        let view = PostViewController(userId: userId)
        let interactor = PostInteractor()
        let router = PostRouter()
        let presenter = PostPresenter(interface: view, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func route(userId: String, from: UIViewController, animated: Bool) {
        from.navigationController?.pushViewController(createModule(userId: userId), animated: animated)
    }
}
