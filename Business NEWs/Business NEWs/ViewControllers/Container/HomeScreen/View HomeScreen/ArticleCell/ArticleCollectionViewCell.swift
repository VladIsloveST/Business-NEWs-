//
//  ArticleCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 09.06.2023.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArticleCollectionViewCell"
    
    lazy var articlCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset.top = 15
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setuopRefreshControl()
    }
    
    // MARK: - Actions
    func setupCollectionView() {
        articlCollectionView.delegate = self
        articlCollectionView.dataSource = self
        
        articlCollectionView.register(PortraitCollectionViewCell.self,
                                forCellWithReuseIdentifier: PortraitCollectionViewCell.identifier)
        addSubview(articlCollectionView)
        articlCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articlCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            articlCollectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        articlCollectionView.refreshControl = refreshControl
    }
    
    func setuopRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more articles...", attributes: [NSAttributedString.Key.strokeColor : UIColor.black])
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        print("refresh")
        sender.endRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Collection View Data Source
extension ArticleCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortraitCollectionViewCell.identifier, for: indexPath) as? PortraitCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: - Collection View Delegate
extension ArticleCollectionViewCell: UICollectionViewDelegate {
    
}

// MARK: - Collection View Delegate Flow Layout
extension ArticleCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let widnestCellWigth = bounds.width - collectionView.contentInset.left - collectionView.contentInset.left
//        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
//        let size = CGSize(width: widnestCellWigth, height: 2000)
//        let estimatedFrame = NSString(string: wikipedia[indexPath.row]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//        return CGSize(width: widnestCellWigth, height: estimatedFrame.height + 25)
        
        CGSize(width: frame.width - 30, height: frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
