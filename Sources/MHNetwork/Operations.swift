//
//  Operation.swift
//  MHNetwork
//
//  Created by Mohamed Emad Abdalla Hegab on 01.02.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//

import Foundation

public protocol Operations {

    associatedtype Output

    var request: Request { get }

    func execute(in dispatcher: Dispatcher, completed: @escaping (Result<Output,NetworkError>) -> Void)
}
