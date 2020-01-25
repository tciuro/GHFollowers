//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/25/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.setItemInfo(type: .repos, count: user.publicRepos)
        itemInfoViewTwo.setItemInfo(type: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
