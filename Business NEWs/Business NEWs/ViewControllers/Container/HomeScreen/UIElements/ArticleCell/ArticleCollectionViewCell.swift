//
//  ArticleCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 09.06.2023.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArticleCollectionViewCell"
    
    var articleCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private var separatorLine: UIView!
    var delegat: HomeViewControllerShareDelegate?

    var didFetchData: (Int) -> () = {_ in }
    
//    private var totalNumbers = 8 {
//        didSet {
//            print("totalNumbers increase")
//            articleCollectionView.reloadData()
//        }
//    }
    
    var articles: [ArticleData] = [] {
        didSet {
            articleCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupRefreshControl()
        addSeparatorLineView()
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
        let layout = CustomFlowLayout(section: section, numberOfItemsInSection: 4)
        return layout
    }
    
    private func setupCollectionView() {
        articleCollectionView = UICollectionView(frame: .zero, collectionViewLayout:  createLayout())
       
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.prefetchDataSource = self
        
        articleCollectionView.register(LargePortraitCell.self,
                                forCellWithReuseIdentifier: LargePortraitCell.identifier)
        articleCollectionView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identifier)
        addSubview(articleCollectionView)
        articleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            articleCollectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        articleCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        articleCollectionView.backgroundColor = .systemGray3
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching more articles...", attributes: [NSAttributedString.Key.strokeColor : UIColor.black])
        articleCollectionView.refreshControl = refreshControl
    }
    
    @objc
    private func refresh(sender: UIRefreshControl) {
        didFetchData(16)
        sender.endRefreshing()
    }
    
    private func addSeparatorLineView(){   
        separatorLine = UIView()
        addSubview(separatorLine)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.widthAnchor.constraint(equalToConstant: frame.width),
            separatorLine.topAnchor.constraint(equalTo: articleCollectionView.topAnchor)
        ])
        separatorLine.backgroundColor = .black
    }
    
    func convertDateFormater(_ date: String) -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let newDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "EEEE, MMM d"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            fixDate = dateFormatter.string(from: newDate)
        }
        return fixDate
    }
}

// MARK: - Collection View Data Source
extension ArticleCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let portraitCell = collectionView.dequeueReusableCell(withReuseIdentifier: LargePortraitCell.identifier, for: indexPath) as? LargePortraitCell else { return cell }
        guard let smallCell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallCell.identifier, for: indexPath) as? SmallCell else { return cell }
        let article = articles[indexPath.row]
        
        if indexPath.row % 4 == 0 {
            portraitCell.didShare = { [weak self] in
                guard let url = URL(string: article.url) else { return }
                self?.delegat?.presentShareSheet(url: url)
            }
            portraitCell.mainLabel.text = article.title
            portraitCell.authorLable.text = article.author
            portraitCell.convertDateFormater(article.publishedAt)
            return portraitCell
        } else {
            smallCell.didShare = { [weak self] in
                guard let url = URL(string: article.url) else { return }
                self?.delegat?.presentShareSheet(url: url)
            }
            smallCell.mainLabel.text = article.title
            smallCell.authorLable.text = article.author
            smallCell.convertDateFormater(article.publishedAt)
            return smallCell
        }
    }
}

// MARK: - Collection View Data Source Prefetching
extension ArticleCollectionViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("prefetchItemsAt")
//        let filtered = indexPaths.filter({ $0.row >= totalNumbers - 5})  // - 1 - 4 (1 блок)
//        if filtered.count > 0 {
//            totalNumbers += 8
//        }
//
//        filtered.forEach({_ in
//            self.didFetchData(totalNumbers)
//        })
    }
}

// MARK: - Collection View Delegate
extension ArticleCollectionViewCell: UICollectionViewDelegate {
}

