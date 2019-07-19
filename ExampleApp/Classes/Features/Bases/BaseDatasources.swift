//
//  BaseDatasources.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

import UIKit

protocol BaseTableDataSource: class, UITableViewDelegate, UITableViewDataSource {
    associatedtype ItemType
    var items: [ItemType] { get set }
}
