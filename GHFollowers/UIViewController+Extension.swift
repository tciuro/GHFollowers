//
//  UIViewController+Extension.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/5/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentGHAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
}
