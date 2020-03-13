//
//  ViewController.swift
//  Coronavirus
//
//  Created by Apple on 3/13/20.
//  Copyright © 2020 Hieu Le. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {

    private let cellID = "cellID"
    private let headerID = "headerID"
    private let footerID = "footerID"
    
    private var countries = [Country]()
    private var filteredCountries = [Country]()
    private var isLoading = false {
        didSet {
            if isLoading {
                searchController.searchBar.isUserInteractionEnabled = false
                navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                searchController.searchBar.isUserInteractionEnabled = true
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    private var isSearching = false
    
    private var lastUpdate: String?
    
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COVID 19"
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWithIndicator))
        //navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        //navigationItem.rightBarButtonItem?.image = UIImage(named: <#T##String#>)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showRoadMap))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        
        setupRefreshControl()
        setupSearchController()
        setupCollectionView()
        setupActivityIndicator()
        getSavedData()
        loadData(withIndicator: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateCollectionView()
    }
    
    
    // MARK: -- SETUP METHODS
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a country"
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        collectionView.register(CountryCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: headerID)
        collectionView.register(FooterCell.self, forCellWithReuseIdentifier: footerID)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func toggleActivityIndicator() {
        isLoading = !isLoading
        activityIndicator.isAnimating ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    
    // MARK: -- CLASS METHODS
    
    private func loadData(withIndicator showIndicator: Bool) {
        if showIndicator {
            toggleActivityIndicator()
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let countriesList = CoronavirusAPI.getCountries()
            
            if countriesList.count > 0 {
                self?.countries = countriesList
                
                if let countries = self?.countries { self?.filteredCountries = countries }
                if let date = CoronavirusAPI.lastUpdateDate {
                    self?.lastUpdate = date
                }
                self?.saveData()
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.refreshControl.endRefreshing()
                    
                    if showIndicator {
                        self?.toggleActivityIndicator()
                    }
                }
            }
        }
    }
    
    private func getSavedData() {
        let defaults = UserDefaults.standard
        
        if let date = defaults.string(forKey: "lastUpdateDate") {
            lastUpdate = date
        }
        
        if let savedCountries = defaults.object(forKey: "countries") as? Data {
            let decoder = JSONDecoder()

            do {
                countries = try decoder.decode([Country].self, from: savedCountries)
                filteredCountries = countries
                collectionView.reloadData()
            } catch {
                print("Failed to load countries.")
            }
        }
    }
    
    private func saveData() {
        let defaults = UserDefaults.standard
        
        defaults.set(CoronavirusAPI.lastUpdateDate, forKey: "lastUpdateDate")
        
        let jsonEncoder = JSONEncoder()
        
        if let data = try? jsonEncoder.encode(countries) {
            defaults.set(data, forKey: "countries")
        } else {
            print("Failed to save countries.")
        }
    }
    
    @objc private func refresh() {
        if !isSearching {
            loadData(withIndicator: false)
        }
    }
    
    @objc private func refreshWithIndicator() {
        loadData(withIndicator: true)
    }
    
    @objc private func animateCollectionView() {
        let items = collectionView.visibleCells.sorted(by: { $0.layer.position.y < $1.layer.position.y })
        
        if items.count > 0 {
            let height = collectionView.bounds.size.height
            
            for item in items {
                item.transform = CGAffineTransform(translationX: 0, y: height + 90)
            }
            
            var delayCounter: Double = 0
            for item in items {
                UIView.animate(withDuration: 1, delay: delayCounter * 0.025, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    item.transform = .identity
                }, completion: nil)
                delayCounter += 1
            }
        }
    }

    @objc private func showRoadMap() {
        let message = """

            - [x]  Header with sums of each displayed countries

            - [x]  Fix scrolling bug on search

            - [x]  Add API sources (at the buttom of the screen ?)

            - [x] Country view with map and informations + last update date

            - [x] CollectionView animations

            - [x] Drag to reload

            - [x] Add recovered percentage in country view

            - [x] Sharing features

            - [ ] Refresh when entering foreground

            - [ ] Refresh in background

            - [ ] Add notifications if country overpass amount of confirmed or deaths

            - [x] Fix Cells constraints (bug when changing orientation)

            - [ ] Manage dark and white mode

            - [x] Load data in background + add loader

            - [x] User defaults for offline mode
        """
        let ac = UIAlertController(title: "Road map 🗺", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default))
        
        present(ac, animated: true)
    }
    
    private func filterCountriesBy(name: String) {
        var list = [Country]()
        
        if name.count != 0 {
            for country in countries {
                if country.country.lowercased().contains(name.lowercased()) {
                    list.append(country)
                }
            }
            filteredCountries = list
        } else {
            filteredCountries = countries
        }
        
        collectionView.reloadData()
    }
}



// -----------------------------------
// MARK: -- COLLECTION VIEW DELEGATES
// ---------------------------------

extension ViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Header
        if section == 0 || section == 2 {
            return 1
        }
        
        // Country
        return filteredCountries.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Header
        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableCell(withReuseIdentifier: headerID, for: indexPath) as! HeaderCell
            header.countries = filteredCountries
            header.lastUpdate = lastUpdate
            return header
        } else if indexPath.section == 2 {
            let footer = collectionView.dequeueReusableCell(withReuseIdentifier: footerID, for: indexPath) as! FooterCell
            return footer
        }
        
        // Country
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CountryCell
        cell.country = filteredCountries[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 20
        let height: CGFloat = 90.0// width * 0.3
        
        if indexPath.section == 0 {
            return .init(width: width, height: height * 0.75)
        } else if indexPath.section == 1 {
            return .init(width: width, height: height)
        }
        return .init(width: width * 0.75, height: height * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .init(top: 20, left: 0, bottom: 20, right: 0)
        } else if section == 1 {
            return .init(top: 20, left: 0, bottom: 40, right: 0)
        }
        return .init(top: 15, left: 0, bottom: 10, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = CountryViewController()
            vc.country = filteredCountries[indexPath.item]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



// ------------------------------------------
// MARK: -- SEARCH RESULTS UPDATER DELEGATES
// ----------------------------------------

extension ViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        isSearching = text.count > 0
        filterCountriesBy(name: text)
    }
}
