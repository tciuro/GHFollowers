//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/4/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GFTextField()
    let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    
    private var isUsernameEntered: Bool { return !(usernameTextField.text?.isEmpty ?? false) }
    
    private var networkManager: GHNetworkCapable!
    
    init(networkManager: GHNetworkCapable) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGHAlertOnMainThread(title: "Empty Username", message: "Please enter the username. We need to know what to look for. 😉", buttonTitle: "OK")
            return
        }
        
        let followerListVC = FollowerListVC(username: usernameTextField.text!, networkManager: networkManager)
        followerListVC.title = usernameTextField.text
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    private func configureLogoView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80.0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200.0),
            logoImageView.widthAnchor.constraint(equalToConstant: 200.0)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(usernameTextField)
        
        usernameTextField.autocapitalizationType = .none
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48.0),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
