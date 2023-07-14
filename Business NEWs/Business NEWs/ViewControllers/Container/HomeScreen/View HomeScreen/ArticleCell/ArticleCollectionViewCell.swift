//
//  ArticleCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 09.06.2023.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArticleCollectionViewCell"
    
    private var articlCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    private func createLayout() -> CustomFlowLayout {
        let topItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1)))
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1)))
        let localVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(400)),
            subitem: item, count: 3)
        let generalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(600)),
            subitems: [topItem, localVerticalGroup])
        generalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: generalGroup)
        section.interGroupSpacing = 80
        let layout = CustomFlowLayout(section: section)
        return layout
    }
    
    private func setupCollectionView() {
        articlCollectionView = UICollectionView(frame: .zero, collectionViewLayout:  createLayout())
       
        articlCollectionView.dataSource = self
        articlCollectionView.delegate = self
        
        //articlCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        articlCollectionView.register(LargePortraitCell.self,
                                forCellWithReuseIdentifier: LargePortraitCell.identifier)
        articlCollectionView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identifier)
        addSubview(articlCollectionView)
        articlCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articlCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            articlCollectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        articlCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        articlCollectionView.backgroundColor = .systemGray3
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more articles...", attributes: [NSAttributedString.Key.strokeColor : UIColor.black])
        articlCollectionView.refreshControl = refreshControl
    }
    
    @objc
    private func refresh(sender: UIRefreshControl) {
        print("refresh")
        sender.endRefreshing()
    }
}

// MARK: - Collection View Data Source
extension ArticleCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        if indexPath.row % 4 == 0 {
            guard let portraitCell = collectionView.dequeueReusableCell(withReuseIdentifier: LargePortraitCell.identifier, for: indexPath) as? LargePortraitCell else { return cell }
            return portraitCell
        } else {
            guard let smallCell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCell.identifier, for: indexPath) as? SmallCell else { return cell }
            return smallCell
        }
    }
}

// MARK: - Collection View Delegate
extension ArticleCollectionViewCell: UICollectionViewDelegate {
}

