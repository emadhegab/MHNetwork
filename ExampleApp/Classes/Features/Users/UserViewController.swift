//
//  UserViewController.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class UserViewController: UIViewController, UserViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    var presenter: UserPresenterProtocol?
    let dataSource = UserDatasources()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasources()
        getUsers()
    }

    
    func reloadData(users: [User]) {
        dataSource.items = users
        tableView.reloadData()
    }
    
    private func setupDatasources() {
        dataSource.delegate = self
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.register(cell: UserCell.self)
    }
    
    private func getUsers() {
        presenter?.getUsers()
    }
}

extension UserViewController: UserDataSourceDelegate {
    func userSelected(user: User) {
        PostRouter.route(userId: "\(user.id)", from: self, animated: true)
    }
}
