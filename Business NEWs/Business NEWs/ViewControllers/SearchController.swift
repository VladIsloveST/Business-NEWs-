//
//  SearchController.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {

    private let myArray = ["First","Second","Third"]
    lazy var myTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return tableView
    }()
    
    lazy var mySearchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        navigationItem.titleView = searchBar
        return searchBar
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.dataSource = self
        myTableView.delegate = self
        mySearchBar.delegate = self
        view.addSubview(myTableView)

        setupNavBarButtons()
    }
    
    private func setupNavBarButtons() {
        let backImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal)
        let backButtonItem = UIBarButtonItem(image: backImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
}
