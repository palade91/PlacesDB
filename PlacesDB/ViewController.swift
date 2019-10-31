//
//  ViewController.swift
//  PlacesDB
//
//  Created by Catalin Palade on 31/10/2019.
//  Copyright © 2019 Catalin Palade. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayCities = [GMSAutocompletePrediction]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        return filter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUI()
    }

    func loadUI() {
        tableView.tableFooterView = UIView()
    }

}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            arrayCities = [GMSAutocompletePrediction]()
        } else {
            GMSPlacesClient.shared().autocompleteQuery(searchText, bounds: nil, filter: filter) { (result, error) in
                if error == nil {
                    if let res = result {
                        self.arrayCities = res
                    }
                }
            }
        }
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.attributedText = arrayCities[indexPath.row].attributedFullText
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "")
        searchBar.text? = ""
        arrayCities = [GMSAutocompletePrediction]()
    }
    
}
