//
//  SearchViewController.swift
//  Business NEWs
//
//  Created by Mac on 07.06.2023.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    var presenter: SearchViewOutPut!
    
    private var timer: Timer?
    
    let searchResultCollectioView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectinView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.headerReferenceSize = CGSize(width: collectinView.frame.size.width, height: 76)
        return collectinView
    }()
    
    
    var historyCollectionView = HistoryCollectionView()
    
    var heightAnchorDown: NSLayoutConstraint?
    var heightAnchorUp: NSLayoutConstraint?
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchResultCollectioView.backgroundColor = .orange
        
        searchBar.delegate = self
        
        searchResultCollectioView.delegate = self
        searchResultCollectioView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.title = "Search"

 //       setUpHistoryView()
        searchResultCollectioView.register(PortraitCell.self,
                                forCellWithReuseIdentifier: PortraitCell.identifier)
        searchResultCollectioView.register(SearchCollectionReusableView.self,
                                    forSupplementaryViewOfKind: SearchCollectionReusableView.kind,
                                    withReuseIdentifier: SearchCollectionReusableView.identifier)
        
        setupSearchCollectioView()
        setupNavBarButtons()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flowUp))
        gestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupSearchCollectioView() {
        view.addSubview(searchResultCollectioView)
        searchResultCollectioView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultCollectioView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultCollectioView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultCollectioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultCollectioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//    private func setUpHistoryView() {
//        view.addSubview(historyCollectionView)
//        heightAnchorDown = historyCollectionView.heightAnchor.constraint(equalToConstant: 120)
//        heightAnchorUp = historyCollectionView.heightAnchor.constraint(equalToConstant: 0)
//        NSLayoutConstraint.activate([
//            historyCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
//            historyCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            historyCollectionView.topAnchor.constraint(equalTo: searchResultCollectioView.topAnchor, constant: 40)
//        ])
//    }
    
    private func flowDown() {
        heightAnchorDown?.isActive = true
        heightAnchorUp?.isActive = false
        UIView.animate(withDuration: 0.75) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func flowUp() {
        heightAnchorDown?.isActive = false
        heightAnchorUp?.isActive = true
        UIView.animate(withDuration: 0.75) {
            self.view.layoutIfNeeded()
        }
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
        guard let text = searchBar.text, !text.isEmpty else { flowUp()
            return }
        
        flowDown()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            print("My Search Bar \(text)")
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        flowDown()
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let searchCell = searchResultCollectioView.dequeueReusableCell(
            withReuseIdentifier: PortraitCell.identifier, for: indexPath) as? PortraitCell else { return cell }
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: SearchCollectionReusableView.identifier, for: indexPath)
                as? SearchCollectionReusableView else { return UICollectionReusableView() }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            header.addSubview(searchBar)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
}

// MARK: - Collection View Delegate Flow Layout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: view.frame.width - 30, height: view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

extension SearchViewController: SearchViewInPut {
    func showUpdateData() {
        self.historyCollectionView.reloadData()
    }
}
