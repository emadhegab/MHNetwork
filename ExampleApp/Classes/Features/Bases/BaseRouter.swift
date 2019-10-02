//
//  BaseRouter.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

import UIKit


protocol BaseRouter {
    func route()
}
class DefaultBaseRouter: BaseRouter {
    
    func route() {
        
        guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else {
            
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
            UIApplication.shared.delegate?.window??.rootViewController =
                UINavigationController(rootViewController: UserRouter.createModule())
            
            return
        }
        
        UserRouter.route(from: rootVC, animated: false)
    }
}
