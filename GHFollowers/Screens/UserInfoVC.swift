//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/15/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit
import SafariServices


protocol FollowerFavoritable: class {
    func followerFavoriteStatusChanged(isFavorite: Bool)
}

class UserInfoVC: UIViewController {
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    weak var delegate: FollowerFavoritable?
    var onDismiss: EmptyCompletion?
    
    private var follower: Follower
    private var networkManager: GHNetworkCapable!
    
    var isUserFavorite: Bool! {
        willSet {
            if newValue {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")!
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")!
            }
        }
    }
    
    init(follower: Follower, networkManager: GHNetworkCapable) {
        self.follower = follower
        self.isUserFavorite = PersistanceManager.shared.isFollowerAlreadyFavorite(follower)
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isUserFavorite && !PersistanceManager.shared.isFollowerAlreadyFavorite(follower) {
            PersistanceManager.shared.addFollowerToFavorites(follower)
            
        } else if !isUserFavorite && PersistanceManager.shared.isFollowerAlreadyFavorite(follower) {
            PersistanceManager.shared.removeFollowerFromFavorites(follower)
        }
        
        delegate?.followerFavoriteStatusChanged(isFavorite: isUserFavorite)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFavoriteButton()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureFavoriteButton() {
        if isUserFavorite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill")!, style: .plain, target: self, action: #selector(setFavoriteButton))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star")!, style: .plain, target: self, action: #selector(setFavoriteButton))
        }
    }
    
    @objc
    private func setFavoriteButton() {
        isUserFavorite.toggle()
    }
    
    private func getUserInfo() {
        networkManager.getUserInfo(for: follower.login) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGHAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    private func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user, networkManager: networkManager), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
        self.setDateLabel(with: user.createdAt)
    }
        
    private func layoutUI() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        let padding: CGFloat = 20.0
        let itemHeight: CGFloat = 140.0
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180.0),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: itemViewTwo.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: itemViewTwo.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    private func setDateLabel(with date: Date) {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "MMMM yyyy"
        
        dateLabel.text = "GitHub since \(formatter.string(from: date))"
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
}

extension UserInfoVC: GitHubProfileTappable {
    func didTapGitHubProfile(of user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGHAlertOnMainThread(title: "User's GitHub Page Missing", message: "The user's profile URL is invalid.", buttonTitle: "OK")
            return
        }
        
        presentSafariController(with: url)
    }
}

extension UserInfoVC: GitHubFollowersTappable {
    func didTapGitHubFollowers(of user: User) {
        let followersVC = FollowerListVC(username: user.login, networkManager: networkManager)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        followersVC.navigationItem.rightBarButtonItem = doneButton
        followersVC.title = user.login
        
        let navController = UINavigationController(rootViewController: followersVC)
        
        present(navController, animated: true)
    }
}
