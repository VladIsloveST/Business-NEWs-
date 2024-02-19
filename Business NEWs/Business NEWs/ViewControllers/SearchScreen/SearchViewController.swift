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
    private var page = 1
    private let currentDateTime = Calendar.current.dateComponents([.hour, .day], from: Date())
    
    private var heightAnchorDown: NSLayoutConstraint?
    private var heightAnchorUp: NSLayoutConstraint?
    private var searchResultCollectioView: UICollectionView!
    private var historyTableView: HistoryTableView!
    private var containerView: UIView!
    private var loadingIndicator: ProgressView!
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchCollectioView()
        setUpContainerView()
        setGesture()
        setupHistoryView()
        setupNavigationBar()
        setupIndicator()
        setupSearchBar()
    }
    
    private func createLayout() -> CustomFlowLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.2)))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(700)),
            repeatingSubitem: item, count: 5)
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
        searchResultCollectioView.isPrefetchingEnabled = true
        
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
        searchResultCollectioView.backgroundColor = .myBackgroundColor
        searchResultCollectioView.contentInset.bottom = 20
    }
    
    private func setGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flowUp))
        gestureRecognizer.numberOfTapsRequired = 1
        searchResultCollectioView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
    }
    
    private func setupHistoryView() {
        historyTableView = HistoryTableView()
        historyTableView.accessibilityIdentifier = "historyTableView"
        containerView.addSubview(historyTableView)
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        historyTableView.constraint(equalToAnchors: containerView)
        historyTableView.mainCellDelegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Search".localized
        let backButtonItem = UIBarButtonItem(
            imageSystemName: "chevron.backward", target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func setUpContainerView() {
        containerView = UIView()
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        heightAnchorDown = containerView.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorUp = containerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: view.frame.width - 50),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: searchResultCollectioView.topAnchor, constant: 53)
        ])
        containerView.layer.addShadow()
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder =  " " + "Search".localized + "..."
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
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
    
    @objc
    private func handleBack() {
        presenter.turnBack()
    }
    
    private func setupIndicator() {
        loadingIndicator = ProgressView()
        searchResultCollectioView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: searchResultCollectioView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: searchResultCollectioView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func performBatchUpdates() {
        let indexPath = IndexPath(item: self.presenter.searchResultArticles.count - 1, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        searchResultCollectioView.performBatchUpdates({ () -> Void in
            searchResultCollectioView.insertItems(at: indexPaths)
        }, completion: nil)
    }
    
    private func presentShareSheet(url: URL) {
        DispatchQueue.main.async {
            let activityViewPopover = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityViewPopover, animated: true)
        }
    }
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return flowDown() }
        
        flowUp()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.presenter.search(line: text.lowercased(), page: 1)
            self?.historyTableView.added(item: text)
            self?.historyTableView.reloadData()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        flowDown()
    }
}

// MARK: - Collection View Data Source
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.searchResultArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let searchCell = searchResultCollectioView.dequeueReusableCell(
            withReuseIdentifier: SmallCell.identifier, for: indexPath) as? SmallCell else { return cell }
        if !presenter.searchResultArticles.isEmpty {
            let article = presenter.searchResultArticles[indexPath.row]
            searchCell.assignCellData(from: article, isSaved: false, currentDate: currentDateTime)
            searchCell.didShare = { [weak self] in
                guard let url = URL(string: article.url) else { return }
                self?.presentShareSheet(url: url)
            }
        }
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SearchCollectionReusableView.identifier,
            for: indexPath) as? SearchCollectionReusableView else { return UICollectionReusableView() }
        if (kind == UICollectionView.elementKindSectionHeader) {
            header.add(searchBar)
            return header
        }
        return UICollectionReusableView()
    }
}

// MARK: - Collection View Delegate
extension SearchViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: presenter.searchResultArticles[indexPath.row].url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Collection View Data Source Prefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let filtered = indexPaths.filter({ $0.row >= presenter.searchResultArticles.count - 4 })
        if filtered.count > 0 {
            page += 1
            presenter.search(line: searchBar.text ?? "", page: page)
        }
    }
}

extension SearchViewController: SearchViewInPut {
    func showUpdateData() {
        loadingIndicator.isAnimating = false
        searchResultCollectioView.reloadData()
    }
}

extension SearchViewController: PopOverTableViewDelegate {
    func selectItem(row: Int,  with action: Action) {
        switch action {
        case .delete:
            self.heightAnchorDown?.constant = self.historyTableView.contentSize.height
        case .revert:
            searchBar.text = historyTableView.searchingHistory[row]
        case .search:
            let selectedRow = historyTableView.searchingHistory[row]
            loadingIndicator.isAnimating = true
            searchBar.text = selectedRow
            presenter.search(line: selectedRow, page: 1)
            flowUp()
        }
    }
}
