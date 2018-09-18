//
//  ViewController.swift
//  QuoteApp
//
//  Created by Mohamed Emad Abdalla Hegab on 17.07.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        QuoteRouter.route(from: self)
    }
}
