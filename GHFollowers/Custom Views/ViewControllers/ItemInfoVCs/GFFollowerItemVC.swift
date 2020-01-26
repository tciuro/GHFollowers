//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/25/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

protocol GitHubFollowersTappable: class {
    func didTapGitHubFollowers(of user: User)
}

class GFFollowerItemVC: GFItemInfoVC {
    
    weak var delegate: GitHubFollowersTappable?

    init(user: User, delegate: GitHubFollowersTappable? = nil) {
        self.delegate = delegate
        super.init(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.setItemInfo(type: .followers, count: user.followers)
        itemInfoViewTwo.setItemInfo(type: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
        actionButton.addTarget(self, action: #selector(didTapGetFollowers), for: .touchUpInside)
    }
    
    @objc private func didTapGetFollowers() {
        if let delegate = self.delegate {
            delegate.didTapGitHubFollowers(of: user)
        }
    }
}
