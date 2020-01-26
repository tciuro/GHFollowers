//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/25/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate: GitHubProfileTappable?
    
    init(user: User, delegate: GitHubProfileTappable? = nil) {
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
        itemInfoViewOne.setItemInfo(type: .repos, count: user.publicRepos)
        itemInfoViewTwo.setItemInfo(type: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
        actionButton.addTarget(self, action: #selector(didTapGetGitHubProfile), for: .touchUpInside)
    }
    
    @objc private func didTapGetGitHubProfile() {
        if let delegate = delegate {
            delegate.didTapGitHubProfile(of: user)
        }
    }
}
