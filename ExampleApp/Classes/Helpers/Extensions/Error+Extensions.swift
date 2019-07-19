//
//  Error+Extensions.swift
//  ExampleApp
//
//  Created by Mohamed Emad Abdalla Hegab on 7/19/19.
//  Copyright © 2019 Mohamed Hegab. All rights reserved.
//

import Foundation

extension Error {
    var convertToErrorItem: ErrorItem {
        return (nil, self, nil)
    }
}
