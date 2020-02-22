//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/4/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {

    enum Section {
        case main
    }
    
    var username: String
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var pageCounter = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    let networkManager: GHNetworkCapable!
    
    init(username: String, networkManager: GHNetworkCapable) {
        self.username = username
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: pageCounter)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Filter Followers"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        let loadingView = showLoadingView()
        networkManager.getFollowers(for: username, page: pageCounter) { [weak self] result in
            guard let self = self else { return }
            
            self.hideLoadingView(loadingView)
            
            switch result {
            case .success(let receivedFollowers):
                if receivedFollowers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: receivedFollowers)
                
                guard !self.followers.isEmpty else {
                    DispatchQueue.main.async {
                        let message = "This user doesn't have any followers. Go follow them! 😃"
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGHAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as? FollowerCell else {
                fatalError("Could not dequeue cell with identifier: \(FollowerCell.reuseID)")
            }
            
            cell.layoutIfNeeded() // Ensure contents are set to their final size.
            cell.set(follower: follower, networkManager: self.networkManager)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {
                return
            }
            pageCounter += 1
            getFollowers(username: username, page: pageCounter)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = filteredFollowers.isEmpty ? followers[indexPath.item] : filteredFollowers[indexPath.item]
        let destinationVC = UserInfoVC(follower: follower, networkManager: networkManager)
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text?.lowercased(), !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            return
        }
        
        filteredFollowers = followers.filter({ follower -> Bool in
            return follower.login.lowercased().contains(filter)
        })
        
        updateData(on: filteredFollowers)
    }
}

extension FollowerListVC: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let followerAvatarURLs = NetworkingHelper.avatarURLs(for: followers, indexPaths: indexPaths)
        guard let indexPath = indexPaths.first, let followerCell = collectionView.cellForItem(at: indexPath) as? FollowerCell else { return }
        networkManager.downloadImages(from: followerAvatarURLs, size: followerCell.avatarImageView.bounds.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let followerAvatarURLs = NetworkingHelper.avatarURLs(for: followers, indexPaths: indexPaths)
        networkManager.cancelDownloadingImages(at: followerAvatarURLs)
    }
    
}
