//
//  HomeViewController.swift
//  Business NEWs
//
//  Created by Mac on 10.02.2023.
//

import UIKit

class SelectedArticlesViewController: UIViewController {
    
    // MARK: - Properties
    private var leftConstraint: NSLayoutConstraint!
    
    private var types = MockData.shared.articleData
    
    lazy private var savedCollectionView: UICollectionView = {
        let flowLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
        
    private var searchBar: UISearchBar!
    private let expandableView = ExpandableView()
    private var coreDataManager: CoreDataProtocol!
    private var articles: [Article] = []
    private var searchedArticles: [Article] = []
    private var searching = false
    private var timer: Timer?
    private let currentDateTime = Calendar.current.dateComponents([.day, .hour], from: Date())
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataManager = CoreDataManager.shared
        setupCollectionView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedCollectionView.backgroundColor = .myBackgroundColor
        articles = coreDataManager.fetchArticles()
        savedCollectionView.reloadData()
        print(articles.count)
        articles.forEach {
            print("\($0.title) - \(articles.firstIndex(of: $0) ?? 404)")
        }
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        savedCollectionView.delegate = self
        savedCollectionView.dataSource = self
        savedCollectionView.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        savedCollectionView.register(PortraitCell.self, forCellWithReuseIdentifier: PortraitCell.identifier)
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
        savedCollectionView.backgroundColor = .myBackgroundColor
        savedCollectionView.bounces = false
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [ weak self ] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.types[sectionIndex]
            switch section {
            case .outdated:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1))
                let group = CompositionalLayout.createGroup(aligment: .horizontal,
                                                            width: .fractionalWidth(0.4),
                                                            height: .fractionalHeight(0.3),
                                                            subitems: item)
                let section = CompositionalLayout.createSection(group: group,
                                                                scrollingBehavior: .continuous)
                section.boundarySupplementaryItems = [self.createSupplementaryHeaderItem()]
                return section
            case .recent:
                let topItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(1)))
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .estimated(100))
                let localVerticalGroup = CompositionalLayout.createGroup(aligment: .vertical,
                                                            width: .fractionalWidth(1),
                                                            height: .estimated(400),
                                                            subitems: item)
                let generalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(400)),
                    subitems: [topItem, localVerticalGroup])
                let section = CompositionalLayout.createSection(group: generalGroup, interGroupSpacing: 0)
                section.boundarySupplementaryItems = [self.createSupplementaryHeaderItem()]
                return section
            }
        }
    }
    
    private func createSupplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(50)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
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
    
    private func presentShareSheet(url: URL) {
        DispatchQueue.main.async {
            let activityViewPopover = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityViewPopover, animated: true)
        }
    }
}

// MARK: - Collection View Data Source

extension SelectedArticlesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
             return searching ? searchedArticles.count : articles.count
        default:
            return 0
        }
//            .types[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        //        guard let storyCell = collectionView.dequeueReusableCell(
        //            withReuseIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell else { return cell }
        //        guard let portraitCell = collectionView.dequeueReusableCell(
        //            withReuseIdentifier: PortraitCell.identifier, for: indexPath) as? PortraitCell else { return cell }
        guard let smallCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SmallCell.identifier, for: indexPath)
                as? SmallCell else { return cell }
        switch types[indexPath.section] {
        case .recent(_):
            //            switch indexPath.item {
            //            case 0:
            //                return portraitCell
            //            default:
            let article = searching ? searchedArticles[indexPath.row] : articles[indexPath.row]
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
            return smallCell
            // }
        case .outdated(_):
            
            return smallCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind
                        kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            header.cellTitleLable.text = types[indexPath.section].name
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Collection View Delegate
extension SelectedArticlesViewController: UICollectionViewDelegate {
}

extension SelectedArticlesViewController: SettingViewControllerDelegate {
    func changeThema() {
        savedCollectionView.backgroundColor = .myBackgroundColor
        print("Invoke")  // спрацьовує, але без зміни кольору
    }
}

// MARK: - Search Bar Delegate
extension SelectedArticlesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.isEmpty {
            searching = true
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                self?.searchedArticles = self?.coreDataManager.searchArticles(with: text) ?? []
            })
        } else {
            searching = false
            searchedArticles.removeAll()
        }
        savedCollectionView.reloadData()
    }
    
}

