//
//  SearchController.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchViewOutPut!
    
    private var timer: Timer?
    
    var historyCollectionView = HistoryCollectionView()
    
    var heightAnchorDown: NSLayoutConstraint?
    var heightAnchorUp: NSLayoutConstraint?
    
    lazy var searchBar:UISearchBar = {
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
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Search"
        
        
        searchBar.delegate = self
        
        
        setUpHistoryView()
        setupNavBarButtons()
    }
    
    private func setUpHistoryView() {
        view.addSubview(historyCollectionView)
        heightAnchorDown = historyCollectionView.heightAnchor.constraint(equalToConstant: 120)
        heightAnchorUp = historyCollectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            historyCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            historyCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            historyCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }
    
    private func setupNavBarButtons() {
        let backButtonItem = UIBarButtonItem(
            imageSystemName: "chevron.backward", target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc
    private func handleBack() {
        presenter.turnBack()
    }
}

// MARK: - Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            print("My Search Bar \(text)")
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
}

// MARK: - Table View Delegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(presenter.mockData[indexPath.row])")
    }
}

extension SearchViewController: SearchViewInPut {
    func showUpdateData() {
        //self.searchHistoryTableView.reloadData()
    }
}
