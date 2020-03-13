//
//  HeaderCell.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    private var confirmedLabel = UILabel()
    private var recoveredLabel = UILabel()
    private var deathsLabel = UILabel()
    private var lastUpdateLabel = UILabel()
    
    var countries: [Country]? {
        didSet {
            if let countries = countries {
                let recoveredPercentage = getRecoveredPercentage(countries)
                titleLabel.text = "\(countries.count) countries, \(recoveredPercentage)% recovered"
                confirmedLabel.text = "🤒 \(getTotalConfirmed(countries))"
                recoveredLabel.text = "😀 \(getTotalRecovered(countries))"
                deathsLabel.text = "☠️ \(getTotalDeaths(countries))"
            }
        }
    }
    
    var lastUpdate: String? {
        didSet {
            if let date = lastUpdate {
                lastUpdateLabel.text = "Last update: \(date)"
            } else {
                if let date = CoronavirusAPI.lastUpdateDate {
                    lastUpdateLabel.text = "Last update: \(date)"
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorManager.headerBackgroundColor
        
        setupLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
    
    private func setupLabels() {
        titleLabel.text = "Total: 0"
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        confirmedLabel.text = "🤒 0"
        recoveredLabel.text = "😀 0"
        deathsLabel.text = "☠️ 0"
        
        for label in [confirmedLabel, recoveredLabel, deathsLabel] {
            label.font = .systemFont(ofSize: 13)
            label.textColor = .white
            label.textAlignment = .center
        }
        
        let infosStackView = UIStackView(arrangedSubviews: [confirmedLabel, recoveredLabel, deathsLabel])
        infosStackView.axis = .horizontal
        infosStackView.distribution = .equalSpacing
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, infosStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        addSubview(stackView)
        
        setupStackViewConstraints(stackView: stackView)
        
        lastUpdateLabel.text = ""
        lastUpdateLabel.font = .systemFont(ofSize: 12)
        addSubview(lastUpdateLabel)
        
        setupLastUpdateLabelConstraints()
    }
    
    private func setupStackViewConstraints(stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupLastUpdateLabelConstraints() {
        lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lastUpdateLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
    }
    
    private func getTotalConfirmed(_ countries: [Country]) -> Int {
        var totalConfirmed = 0
        for country in countries {
            totalConfirmed += country.confirmed
        }
        
        return totalConfirmed
    }
    
    private func getTotalRecovered(_ countries: [Country]) -> Int {
        var totalRecovered = 0
        for country in countries {
            totalRecovered += country.recovered
        }
        
        return totalRecovered
    }
    
    private func getTotalDeaths(_ countries: [Country]) -> Int {
        var totalDeaths = 0
        for country in countries {
            totalDeaths += country.deaths
        }
        
        return totalDeaths
    }
    
    private func getRecoveredPercentage(_ countries: [Country]) -> Double {
        let totalConfirmed = Double(getTotalConfirmed(countries))
        let totalRecovered = Double(getTotalRecovered(countries))
        
        if totalConfirmed == 0 {
            return 0.0
        }
        
        return round(totalRecovered / totalConfirmed * 1000) / 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
