//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/4/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites = PersistanceManager.shared.favoriteFollowers()
        if favorites.isEmpty {
            showEmptyStateView(with: "There are no Favorites. Tap on a follower and tap \"Add", in: self.view)
        } else {
            tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension FavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = UserInfoVC(follower: favorite)
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        PersistanceManager.shared.removeFollowerFromFavorites(favorite)
    }
}

extension FavoritesListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath)

        if let followerCell = cell as? FavoriteCell {
            let favorite = favorites[indexPath.row]
            followerCell.set(favorite: favorite)
        }
        
        return cell
    }
    
}
