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
        configureUIVisibility()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeEmptyStateView(in: view)
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
    
    private func configureUIVisibility() {
        favorites = PersistanceManager.shared.favoriteFollowers()
        if favorites.isEmpty {
            tableView.isHidden = true
            showEmptyStateView(with: "There are no Favorites.\n\nGo to a follower and tap ✩.", in: self.view)
        } else {
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func deleteRow(at indexPath: IndexPath?) {
        if let indexPath = indexPath {
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            configureUIVisibility()
        }
    }

}

extension FavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = UserInfoVC(follower: favorite)
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        PersistanceManager.shared.removeFollowerFromFavorites(favorite)
        deleteRow(at: indexPath)
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

extension FavoritesListVC: FollowerFavoritable {
    
    func followerFavoriteStatusChanged(status: FollowerStatus) {
        deleteRow(at: tableView.indexPathForSelectedRow)
    }
    
}
