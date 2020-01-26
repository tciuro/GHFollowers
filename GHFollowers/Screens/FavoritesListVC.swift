//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/4/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        
        print(PersistanceManager.shared.favoriteFollowers())
    }

}
