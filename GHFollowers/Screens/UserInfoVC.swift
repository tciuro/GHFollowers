//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/15/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    private var username: String
    
    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.title = username
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

}
