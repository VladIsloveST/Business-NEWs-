//
//  HomeViewController.swift
//  Business NEWs
//
//  Created by Mac on 10.02.2023.
//

import UIKit

class SelectedArticlesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var types = MockData.shared.articleData
    
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newsCollectionView: UICollectionView! {
        didSet {
            newsCollectionView.dataSource = self
            newsCollectionView.delegate = self
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        newsCollectionView.refreshControl = myRefreshControl
        newsCollectionView.collectionViewLayout = createLayout()
    }
    
    // MARK: - Private Methods
    
    @objc private func refresh(sender: UIRefreshControl) {
        let newPortrait = types.append(.portrait([Article(title: "")]))
        newsCollectionView.reloadData()
        sender.endRefreshing()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [ weak self ] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.types[sectionIndex]
            switch section {
            case .story:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1))
                let group = CompositionalLayout.createGroup(aligment: .horizontal,
                                                            width: .absolute(70),
                                                            height: .absolute(70),
                                                            subitems: item)
                let section = CompositionalLayout.createSection(group: group,
                                                                interGroupSpacing: 10,
                                                                scrollingBehavior: .continuous)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                return section
            case .portrait:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1),
                                                          height: .fractionalHeight(1))
                let group = CompositionalLayout.createGroup(aligment: .vertical,
                                                            width: .fractionalWidth(0.9),
                                                            height: .fractionalWidth(0.6),
                                                            subitems: item)
                let section = CompositionalLayout.createSection(group: group,
                                                                interGroupSpacing: 10)
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
}

// MARK: - Collection View Data Source

extension SelectedArticlesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        types[section].count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch types[indexPath.section] {
            
        case .portrait(_):
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! StoryCollectionViewCell
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "portraitCell", for: indexPath) as! PortraitCollectionViewCell
                
                return cell
            }
            
            
        case .story(_):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "storyCell", for: indexPath) as! StoryCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerReusableView", for: indexPath) as! CollectionViewHeaderReusableView
            header.headerLabel.text = types[indexPath.section].name
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Collection View Delegate

extension SelectedArticlesViewController: UICollectionViewDelegate {
    
}
