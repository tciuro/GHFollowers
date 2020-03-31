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
    
    private var networkManager: GHNetworkCapable
    
    init(networkManager: GHNetworkCapable) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func deleteRow(at indexPath: IndexPath) {
        
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        configureUIVisibility()
    
    }
    
    private func deselectTableView() {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

}

extension FavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = UserInfoVC(follower: favorite, networkManager: networkManager)
        destinationVC.delegate = self
        destinationVC.onDismiss = {
            self.deselectTableView()
        }
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
            followerCell.layoutIfNeeded() // Ensure contents are set to their final size.
            followerCell.set(favorite: favorite, networkManager: networkManager)
        }
        
        return cell
    }
    
}

extension FavoritesListVC: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let favoritesAvatarURLs = NetworkingHelper.avatarURLs(for: favorites, indexPaths: indexPaths)
        guard let indexPath = indexPaths.first, let favoriteCell = tableView.cellForRow(at: indexPath) as? FavoriteCell else { return }
        networkManager.downloadImages(from: favoritesAvatarURLs, size: favoriteCell.avatarImageView.bounds.size)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        let favoritesAvatarURLs = NetworkingHelper.avatarURLs(for: favorites, indexPaths: indexPaths)
        networkManager.cancelDownloadingImages(at: favoritesAvatarURLs)
    }
    
}

extension FavoritesListVC: FollowerFavoritable {
    func followerFavoriteStatusChanged(isFavorite: Bool) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        if !isFavorite {
            deleteRow(at: indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
