//
//  HomeViewController.swift
//  Business NEWs
//
//  Created by Mac on 10.02.2023.
//

import UIKit

class SelectedArticlesViewController: UIViewController {
    
    // MARK: - Private Properties
    private let currentDateTime = Calendar.current.dateComponents([.day, .hour], from: Date())
    private var leftConstraint: NSLayoutConstraint!
    private var searchBar: UISearchBar!
    private var expandableView: ExpandableView!
    private var coreDataManager: CoreDataProtocol!
    private var savedArticles: [Article] = []
    private var searchedArticles: [Article] = []
    private var isSearching = false
    private var timer: Timer?
    private var cells: [BasicCollectionViewCell] = []
    lazy private var savedCollectionView: UICollectionView = {
        let flowLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notifyColorChange(notification:)),
                                               name: .appearanceDidChange, object: nil)
        coreDataManager = CoreDataManager.shared
        setupCollectionView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedArticles = coreDataManager.fetchArticles()
        savedCollectionView.reloadData()
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        savedCollectionView.delegate = self
        savedCollectionView.dataSource = self
        savedCollectionView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identifier)
        savedCollectionView.register(CollectionReusableView.self,
                                    forSupplementaryViewOfKind: CollectionReusableView.kind,
                                    withReuseIdentifier: CollectionReusableView.identifier)
        view.addSubview(savedCollectionView)
        savedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savedCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            savedCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            savedCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        savedCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        savedCollectionView.backgroundColor = .myBackgroundColor
        //savedCollectionView.bounces = false
    }
    
    private func createLayout() -> CustomFlowLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(140)))
        let localVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(400)),
            repeatingSubitem: item, count: 5)
        
        localVerticalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: localVerticalGroup)
        section.interGroupSpacing = 80
        let layout = CustomFlowLayout(section: section, numberOfItemsInSection: 5)
        return layout
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        expandableView = ExpandableView()
        expandableView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableView.leftAnchor, constant: 12)
        NSLayoutConstraint.activate([
            searchBar.rightAnchor.constraint(equalTo: expandableView.rightAnchor),
            searchBar.topAnchor.constraint(equalTo: expandableView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor)
        ])
        searchBar.delegate = self
        navigationItem.titleView = expandableView
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageSystemName: "magnifyingglass",
                                                            target: self, action: #selector(toggle))
    }
    
    @objc
    private func toggle() {
        let isOpen = leftConstraint.isActive == true
        leftConstraint.isActive = isOpen ? false : true
        UIView.animate(withDuration: 0.7, animations: {
            self.navigationItem.titleView?.alpha = isOpen ? 0 : 1
            self.navigationItem.titleView?.layoutIfNeeded()
        })
    }
    
    @objc
    private func notifyColorChange(notification: NSNotification) {
        savedCollectionView.backgroundColor = .myBackgroundColor
        cells.forEach{ $0.setupColor() }
    }
    
    private func presentShareSheet(url: URL) {
        let activityViewPopover = UIActivityViewController(activityItems: [url], 
                                                           applicationActivities: nil)
        self.present(activityViewPopover, animated: true)
    }
}

// MARK: - Collection View Data Source and Delegate
extension SelectedArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
             return isSearching ? searchedArticles.count : savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let smallCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SmallCell.identifier, for: indexPath)
                as? SmallCell else { return cell }
        let article = isSearching ? searchedArticles[indexPath.row] : savedArticles[indexPath.row]
        let articleData = ArticleData(author: article.author, title: article.title,
                                      url: article.url, publishedAt: article.publishedAt)
        smallCell.assignCellData(from: articleData, isSaved: true, currentDate: currentDateTime)
        smallCell.didSelecte = { [weak self] in
            smallCell.buttonSaving.isSelected ?
            self?.coreDataManager.deleteArticle(id: articleData.title)
            : self?.coreDataManager.createArticle(articleData)
        }
        smallCell.didShare = { [weak self] in
            guard let url = URL(string: articleData.url) else { return }
            self?.presentShareSheet(url: url)
        }
        cells.append(smallCell)
        return smallCell
    }
}

// MARK: - Search Bar Delegate
extension SelectedArticlesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.isEmpty {
            isSearching = true
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
                self?.searchedArticles = self?.coreDataManager.searchArticles(with: text.lowercased()) ?? []
                self?.savedCollectionView.reloadData()
            }
        } else {
            isSearching = false
            searchedArticles.removeAll()
            savedCollectionView.reloadData()
        }
    }
}
