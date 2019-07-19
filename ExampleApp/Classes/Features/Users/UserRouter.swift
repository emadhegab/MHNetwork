//
//  UserRouter.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class UserRouter {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = UserViewController(nibName: nil, bundle: nil)
        let interactor = UserInteractor()
        let router = UserRouter()
        let presenter = UserPresenter(interface: view, interactor: interactor)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func route(from: UIViewController, animated: Bool) {
        from.navigationController?.pushViewController(createModule(), animated: animated)
    }
}
