//
//  PostViewController.swift
//  TypiCodeUsers
//
//  Created Mohamed Hegab on 10/29/18.
//  Copyright © 2019 MHNetwork All rights reserved.
//


import UIKit

class PostViewController: UIViewController, PostViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    var presenter: PostPresenterProtocol?
    var userId: String
    let dataSource = PostDatasources()
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasources()
        getPosts()
    }

    
    func reloadData(posts: [Post]) {
        dataSource.items = posts
        tableView.reloadData()
    }
    
    private func setupDatasources() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.register(cell: PostCell.self)
    }
    
    private func getPosts() {
        presenter?.getPosts(userId: userId)
    }
}
