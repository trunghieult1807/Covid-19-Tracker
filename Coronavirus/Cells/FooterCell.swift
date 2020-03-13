//
//  FooterCell.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class FooterCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupLabel()
    }
    
    private func setupLabel() {
        let label = UILabel()
        label.text = CoronavirusAPI.owner
        label.font = .systemFont(ofSize: 12)
        label.textColor = ColorManager.footerTextColor
        label.numberOfLines = 2
        label.textAlignment = .center
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
