//
//  PostsDatasources.swift
//  TypiCodeUsers
//
//  Created by Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//

import UIKit

class PostDatasources: NSObject, BaseTableDataSource {
    
    var items: [Post] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseId) as? PostCell else { return UITableViewCell(frame: CGRect.zero) }
        let post = self[indexPath]
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        return cell
    }
}


extension PostDatasources {
    subscript(indexPath: IndexPath) -> Post {
        return items[indexPath.row]
    }
}
