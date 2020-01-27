//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/15/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    private var messageLabel: GFTitleLabel!
    private var logoImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(message: String) {
        super.init(frame: .zero)
        configure(message: message)
    }
    
    
    private func configure(message: String = "<not set>") {
        messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
        logoImageView = UIImageView()

        addSubview(logoImageView)
        addSubview(messageLabel)
        
        messageLabel.text = message
        messageLabel.numberOfLines = 4
        messageLabel.textColor = .secondaryLabel
        
        logoImageView.image = UIImage(named: "empty-state-logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 70.0),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }
}
