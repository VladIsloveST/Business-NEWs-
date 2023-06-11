//
//  SearchController.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    private var myArray = ["First","Second","Third"]
    
    lazy var searchHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.register(SearchCell.self, forCellReuseIdentifier: "MyCell")
        tableView.tableHeaderView = mySearchBar
        return tableView
    }()
    
    lazy var mySearchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Search"
        
        searchHistoryTableView.dataSource = self
       // searchHistoryTableView.delegate = self
        mySearchBar.delegate = self
        
        view.addSubview(searchHistoryTableView)
        
        setupNavBarButtons()
    }
    
    private func setupNavBarButtons() {
        let backButtonItem = UIBarButtonItem(
            imageSystemName: "chevron.backward", target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        print(text)
    }
}

// MARK: - Table View Data Source

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? SearchCell else { return UITableViewCell() }
        cell.textLabel?.text = "\(myArray[indexPath.row])"
        cell.didDelete = { [unowned self] in
            self.myArray.remove(at: indexPath.row)
            self.searchHistoryTableView.reloadData()
        }
        return cell
    }
}

// MARK: - Table View Delegate

//extension SearchViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(myArray[indexPath.row])")
//    }
//}
