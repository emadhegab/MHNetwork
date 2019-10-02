//
//  UserDatasources.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

import UIKit

protocol UserDataSourceDelegate: class {
    func userSelected(user: User)
}
class UserDatasources: NSObject, BaseTableDataSource {
    
    var items: [User] = []
    weak var delegate: UserDataSourceDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseId) as? UserCell else { return UITableViewCell(frame: CGRect.zero) }
        let user = self[indexPath]
        
        cell.nameLabel.text = "\"\(user.name)\""
        cell.usernameLabel.text = user.username
        cell.emailLabel.text = user.email
        cell.addressLabel.text = user.fullAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self[indexPath]
        delegate?.userSelected(user: user)
    }
}


extension UserDatasources {
    subscript(indexPath: IndexPath) -> User {
        return items[indexPath.row]
    }
}
