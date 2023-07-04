//
//  HomeViewController.swift
//  Business NEWs
//
//  Created by Mac on 10.02.2023.
//

import UIKit

class SelectedArticlesViewController: UIViewController {
    
    // MARK: - Properties
    var leftConstraint: NSLayoutConstraint!
    
    private var types = MockData.shared.articleData
    
    private let newsCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewFlowLayout())
    private let searchBar = UISearchBar()
    private let expandableView = ExpandableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        newsCollectionView.collectionViewLayout = createLayout()
        setupCollectionView()
        setupSearchBar()
    }
    
    // MARK: - Private Methods
    private func  setupCollectionView() {
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        
        newsCollectionView.register(StoryCell.self,
                                    forCellWithReuseIdentifier: StoryCell.identifier)
        newsCollectionView.register(PortraitCell.self,
                                    forCellWithReuseIdentifier: PortraitCell.identifier)
        newsCollectionView.register(CollectionReusableView.self,
                                    forSupplementaryViewOfKind: CollectionReusableView.kind,
                                    withReuseIdentifier: CollectionReusableView.identifier)
        view.addSubview(newsCollectionView)
        newsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newsCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            newsCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case .recent:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1))
                let group = CompositionalLayout.createGroup(aligment: .vertical,
                                                            width: .fractionalWidth(1),
                                                            height: .fractionalHeight(0.4),
                                                            subitems: item)
                let section = CompositionalLayout.createSection(group: group)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            }
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                heightDimension: .estimated(50)),
              elementKind: UICollectionView.elementKindSectionHeader,
              alignment: .top)
    }
    
    func setupSearchBar() {
        expandableView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableView.leftAnchor)
        NSLayoutConstraint.activate([
            searchBar.rightAnchor.constraint(equalTo: expandableView.rightAnchor),
            searchBar.topAnchor.constraint(equalTo: expandableView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor)
        ])
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
}

// MARK: - Collection View Data Source

extension SelectedArticlesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        types[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let storyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell else { return cell }
        guard let portraitCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PortraitCell.identifier, for: indexPath) as? PortraitCell else { return cell }
        
        switch types[indexPath.section] {
        case .recent(_):
            switch indexPath.item {
            case 0:
                return storyCell
            default:
                return portraitCell
            }
        case .outdated(_):
            return storyCell
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
