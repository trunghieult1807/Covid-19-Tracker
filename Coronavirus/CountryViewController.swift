//
//  CountryViewController.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//
import UIKit
import MapKit

class CountryViewController: UIViewController, UIActivityItemSource {
    
    var country: Country! = nil
    
    private let map = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = country.country
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        setupMap()
        setupLabels()
    }
    
    
    // MARK: -- SETUP METHODS
    
    private func setupMap() {
        map.layer.cornerRadius = 15
        map.mapType = .standard
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: country.latitude, longitude: country.longitude)
        annotation.title = country.country
        annotation.subtitle = "\(country.confirmed) confirmed"
        map.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        map.setRegion(region, animated: true)
        
        view.addSubview(map)
        setupMapConstraints()
    }
    
    private func setupMapConstraints() {
        map.translatesAutoresizingMaskIntoConstraints = false
        map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        map.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        map.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -110).isActive = true
    }
    
    private func setupLabels() {
        let labelsStackView = getInfoLabelsStackView()
        let recoverPercentageLabel = getRecoveredPercentageLabel()
        let lastUpdateLabel = getLastUpdateDateLabel()
        
        let infosStackView = UIStackView(arrangedSubviews: [labelsStackView, recoverPercentageLabel, lastUpdateLabel])
        infosStackView.axis = .vertical
        infosStackView.distribution = .equalSpacing
        infosStackView.alignment = .fill
        view.addSubview(infosStackView)
        
        infosStackView.translatesAutoresizingMaskIntoConstraints = false
        infosStackView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 10).isActive = true
        infosStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infosStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 30).isActive = true
        infosStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    private func getInfoLabelsStackView() -> UIStackView {
        let confirmedLabel = UILabel()
        confirmedLabel.text = "🤒 \(country.confirmed)"
        let recoveredLabel = UILabel()
        recoveredLabel.text = "😀 \(country.recovered)"
        let deathsLabel = UILabel()
        deathsLabel.text = "☠️ \(country.deaths)"
        
        for label in [confirmedLabel, recoveredLabel, deathsLabel] {
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 18, weight: .medium)
        }
        
        let labelsStackView = UIStackView(arrangedSubviews: [confirmedLabel, recoveredLabel, deathsLabel])
        labelsStackView.axis = .horizontal
        labelsStackView.distribution = .equalSpacing
        return labelsStackView
    }
    
    private func getRecoveredPercentageLabel() -> UILabel {
        let recoverPercentageLabel = UILabel()
        recoverPercentageLabel.text = "\(getRecoveredPercentage())% recovered"
        recoverPercentageLabel.textAlignment = .center
        recoverPercentageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        return recoverPercentageLabel
    }
    
    private func getRecoveredPercentage() -> Double {
        let totalConfirmed = Double(country.confirmed)
        let totalRecovered = Double(country.recovered)
        
        if totalConfirmed == 0 {
            return 0.0
        }
        
        return round(totalRecovered / totalConfirmed * 1000) / 10
    }
    
    private func getLastUpdateDateLabel() -> UILabel {
        let lastUpdateLabel = UILabel()
        lastUpdateLabel.text = "Last update: \(country.lastUpdate)"
        lastUpdateLabel.textAlignment = .center
        lastUpdateLabel.font = .systemFont(ofSize: 15)
        return lastUpdateLabel
    }
    
    
    // MARK: -- CLASS METHODS
    
    @objc private func share() {
        let vc = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    
    // MARK: -- ACTIVITY CONTROLLER DELEGATES
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return country.country
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let message = "\(country.country) Report:\n\n\(country.confirmed) confirmed.\n\(country.recovered) recovered.\n\(country.deaths) deaths.\n\n\(getRecoveredPercentage())% of confirmed are recovered.\n\nLast update: \(country.lastUpdate)."
        return message
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "Coronavirus \(country.country) report"
    }
}
