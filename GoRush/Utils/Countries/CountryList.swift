//
//  CountryListTableViewController.swift
//  CountryListExample
//
//  Created by Juan Pablo on 9/8/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit

public protocol CountryListDelegate: class {
    func selectedCountry(country: Country)
}

public class CountryList: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var tableView: UITableView!
    var searchController: UISearchController?
    var resultsController = UITableViewController()
    var filteredCountries = [Country]()
    let titleViewController = NSLocalizedString("Country List", comment:"")

    var leftButton:UIBarButtonItem!
    var leftButtonText = NSLocalizedString("Cancel", comment:"")

    
    open weak var delegate: CountryListDelegate?
    
    private var countryList: [Country] {
        let countries = Countries()
        let countryList = countries.countries
        return countryList
    }
    
//    var indexList: [String] {
//        var indexList: [String] = []
//        for country in countryList {
//            if let firstLetter = country.name?.characters.first?.description.lowercased() {
//                if !indexList.contains(firstLetter) { indexList.append(firstLetter) }
//            }
//        }
//        return indexList
//    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.barStyle = .black

    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleViewController
        self.view.backgroundColor = .white
        
        tableView = UITableView(frame: view.frame)
        tableView.register(CountryCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        
        self.view.addSubview(tableView)

        
        leftButton = UIBarButtonItem(title: leftButtonText, style: .plain, target: self, action: #selector(touchLeftButton(_:)))
        navigationItem.leftBarButtonItem = leftButton

        
        setUpSearchBar()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        
        filteredCountries.removeAll()
        
        let text = searchController.searchBar.text!.lowercased()
        
        for country in countryList {
            guard let name = country.name else { return }
            if name.lowercased().contains(text) {
                
                filteredCountries.append(country)
            }
        }
        
        tableView.reloadData()
    }
    
    func setUpSearchBar() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = searchController?.searchBar
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.searchBar.barTintColor = UIColor(hex: "F3F3F3")
        self.searchController?.searchBar.placeholder = "Search"
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.layer.borderWidth = 1
        self.searchController?.searchBar.layer.borderColor = self.searchController?.searchBar.barTintColor?.cgColor

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CountryCell
        let country = cell.country!
        
        self.searchController?.isActive = false
        self.delegate?.selectedCountry(country: country)
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController!.isActive && searchController!.searchBar.text != "" {
            return filteredCountries.count
        }
        
        return countryList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! CountryCell
        
        if searchController!.isActive && searchController!.searchBar.text != "" {
            cell.country = filteredCountries[indexPath.row]
            return cell
        }
        
        cell.country = countryList[indexPath.row]
        return cell
    }
    
    @objc func touchLeftButton(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
}
