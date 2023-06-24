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
        
    private let newsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        return colView
    }()
    
        
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsCollectionView.collectionViewLayout = createLayout()
        setupCollectionView()
    }
    
    // MARK: - Private Methods
    
    private func  setupCollectionView() {
        
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self

        
        newsCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        
        newsCollectionView.register(PortraitCollectionViewCell.self, forCellWithReuseIdentifier: PortraitCollectionViewCell.identifier)
        
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
            
        case .recent(_):
            switch indexPath.item {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortraitCollectionViewCell.identifier, for: indexPath) as? PortraitCollectionViewCell else { return UICollectionViewCell() }
                return cell
            }
            
            
        case .outdated(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as? StoryCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
