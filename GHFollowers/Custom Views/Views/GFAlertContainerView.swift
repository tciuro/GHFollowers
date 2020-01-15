//
//  GFAlertContainerView.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/5/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    init(backgroundColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        super.init(frame: .zero)
        configure(backgroundColor: backgroundColor, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configure(backgroundColor: .systemBackground, cornerRadius: 16.0, borderWidth: 2.0, borderColor: UIColor.white)
    }
    
    private func configure(backgroundColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

}
