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
    
    private let myRefreshControl = UIRefreshControl()
    
    private let newsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return colView
    }()
    
        
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        newsCollectionView.refreshControl = myRefreshControl
        newsCollectionView.collectionViewLayout = createLayout()
        setupCollectionView()
    }
    
    // MARK: - Private Methods
    
    @objc private func refresh(sender: UIRefreshControl) {
        print("refresh")
        sender.endRefreshing()
    }
    
    private func  setupCollectionView() {
        
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self

        
        newsCollectionView.register(
            UINib(nibName: StoryCollectionViewCell.identifier , bundle: nil),
            forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        
        newsCollectionView.register(
            UINib(nibName: PortraitCollectionViewCell.identifier , bundle: nil),
            forCellWithReuseIdentifier: PortraitCollectionViewCell.identifier)
        
        newsCollectionView.register(CollectionReusableView.self,
                                    forSupplementaryViewOfKind: CollectionReusableView.kind,
                                    withReuseIdentifier: CollectionReusableView.identifier)
        
        
        view.addSubview(newsCollectionView)
        newsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            newsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortraitCollectionViewCell.identifier, for: indexPath) as! PortraitCollectionViewCell
                return cell
            }
            
            
        case .story(_):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            header.cellTitleLble.text = types[indexPath.section].name
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - Collection View Delegate

extension SelectedArticlesViewController: UICollectionViewDelegate {
    
}
