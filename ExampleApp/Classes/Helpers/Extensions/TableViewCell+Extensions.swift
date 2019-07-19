//
//  CollectionViewCell+TableViewCell+Extensions.swift
//  Merchant-Platform
//
//  Created by Mohamed Emad Abdalla Hegab on 17.09.18.
//  Copyright © 2018 Dazzler. All rights reserved.
//
import UIKit

extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableView {

    func register(cell: UITableViewCell.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: cell.reuseId)
    }

    func register(cells: [Any.Type]) {
        for cell in cells {
            if let cell = cell as? UITableViewCell.Type {
                register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: cell.reuseId)
            } else if let cell = cell as? UITableViewHeaderFooterView.Type {
                register(UINib(nibName: String(describing: cell), bundle: nil), forHeaderFooterViewReuseIdentifier: cell.reuseId)
            }
        }
    }

    func register(cell: UITableViewHeaderFooterView.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forHeaderFooterViewReuseIdentifier: cell.reuseId)
    }
}
