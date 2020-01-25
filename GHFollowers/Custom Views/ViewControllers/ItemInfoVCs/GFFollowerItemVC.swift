//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/25/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems() {
        itemInfoViewOne.setItemInfo(type: .followers, count: user.followers)
        itemInfoViewTwo.setItemInfo(type: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
