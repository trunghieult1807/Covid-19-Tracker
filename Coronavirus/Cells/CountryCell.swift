//
//  CountryCell.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class CountryCell: UICollectionViewCell {
    
    private var countryLabel = UILabel()
    private var confirmedLabel = UILabel()
    private var recoveredLabel = UILabel()
    private var deathsLabel = UILabel()
    
    var country : Country? {
        didSet {
            if let country = country {
                countryLabel.text = country.country
                confirmedLabel.text = "🤒 \(country.confirmed)"
                recoveredLabel.text = "😀 \(country.recovered)"
                deathsLabel.text = "☠️ \(country.deaths)"
                
                backgroundColor = ColorManager.getColorFrom(infected: country.confirmed)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabels()
        setupRightImage()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 15
    }
    
    private func setupLabels() {
        countryLabel.text = "..."
        countryLabel.font = .systemFont(ofSize: 20, weight: .medium)
        countryLabel.textColor = .white
        countryLabel.adjustsFontSizeToFitWidth = true
        
        confirmedLabel.text = "🤒 ..."
        recoveredLabel.text = "😀 ..."
        deathsLabel.text = "☠️ ..."
        
        for label in [confirmedLabel, recoveredLabel, deathsLabel] {
            label.font = .systemFont(ofSize: 13)
            label.textColor = .white
            label.textAlignment = .center
        }
        
        let infoLabelsStackView = UIStackView(arrangedSubviews: [confirmedLabel, recoveredLabel, deathsLabel])
        infoLabelsStackView.axis = .horizontal
        infoLabelsStackView.distribution = .equalSpacing
        
        let mainStackView = UIStackView(arrangedSubviews: [countryLabel, infoLabelsStackView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        
        addSubview(mainStackView)
        
        setupStackViewConstraints(stackView: mainStackView)
    }
    
    private func setupStackViewConstraints(stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupRightImage() {
        if let image = UIImage(named: "caret") {
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: tintableImage)
            imageView.tintColor = .white
            addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
