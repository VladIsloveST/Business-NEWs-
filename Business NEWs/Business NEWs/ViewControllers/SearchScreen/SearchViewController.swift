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
    
    private var searchResultCollectioView: UICollectionView!
    private var historyTableView: HistoryTableView!
    private var containerView: UIView!
    
    private var heightAnchorDown: NSLayoutConstraint?
    private var heightAnchorUp: NSLayoutConstraint?
    
    private lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.title = "Search"
        
        setupSearchCollectioView()
        setUpContainerView()
        setupHistoryView()
        setupNavBarButtons()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flowUp))
        gestureRecognizer.numberOfTapsRequired = 1
        searchResultCollectioView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func createLayout() -> CustomFlowLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(700)),
            subitem: item, count: 5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 80
        section.boundarySupplementaryItems = [createSupplementaryHeaderItem()]
        let layout = CustomFlowLayout(section: section, numberOfItemsInSection: 5)
        return layout
    }
    
    private func createSupplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(81))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    private func setupSearchCollectioView() {
        searchResultCollectioView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        searchResultCollectioView.delegate = self
        searchResultCollectioView.dataSource = self
        searchResultCollectioView.prefetchDataSource = self
        
        view.addSubview(searchResultCollectioView)
        searchResultCollectioView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchResultCollectioView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultCollectioView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultCollectioView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchResultCollectioView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        searchResultCollectioView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identifier)
        searchResultCollectioView.register(SearchCollectionReusableView.self,
                                           forSupplementaryViewOfKind: SearchCollectionReusableView.kind,
                                           withReuseIdentifier: SearchCollectionReusableView.identifier)
        searchResultCollectioView.backgroundColor = .systemGray3
        searchResultCollectioView.contentInset.bottom = 20
    }
    
    private func setupHistoryView() {
        historyTableView = HistoryTableView()
        containerView.addSubview(historyTableView)
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.constraint(equalToAnchors: containerView)
        historyTableView.mainCellDelegate = self
    }
    
    private func setUpContainerView() {
        containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        heightAnchorDown = containerView.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorUp = containerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width - 24),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: searchResultCollectioView.topAnchor, constant: 53)
        ])
        containerView.layer.addShadow()
    }
    
    private func flowDown() {
        heightAnchorDown?.constant = historyTableView.contentSize.height
        heightAnchorDown?.isActive = true
        heightAnchorUp?.isActive = false
        searchResultCollectioView.isScrollEnabled = false
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func flowUp() {
        heightAnchorDown?.isActive = false
        heightAnchorUp?.isActive = true
        searchResultCollectioView.isScrollEnabled = true
        UIView.animate(withDuration: 0.5) {
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
        guard let text = searchBar.text, !text.isEmpty else { flowDown()
            return }
        
        flowUp()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            print("My Search Bar \(text)")
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        flowDown()
    }
}

// MARK: - Collection View Data Source
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let searchCell = searchResultCollectioView.dequeueReusableCell(
            withReuseIdentifier: SmallCell.identifier, for: indexPath) as? SmallCell else { return cell }
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

// MARK: - Collection View Delegate
extension SearchViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
}

// MARK: - Collection View Data Source Prefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    }
}

extension SearchViewController: SearchViewInPut {
    func showUpdateData() {
        self.historyTableView.reloadData()
    }
}

extension SearchViewController: PopOverTableViewDelegate {
    func selectItem(indexPath: IndexPath) {
        self.heightAnchorDown?.constant = self.historyTableView.contentSize.height
        //searchBar.text = historyTableView.cellConfigureArray[indexPath.row]
    }
}
