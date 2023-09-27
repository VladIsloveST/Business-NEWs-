//
//  ArticleCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 09.06.2023.
//

import UIKit

class ArticlesCollectionViewCell: UICollectionViewCell {
    static let identifier = "ArticleCollectionViewCell"
    
    var articleCollectionView: UICollectionView!
    private var refreshControl: UIRefreshControl!
    private var separatorLine: UIView!
    private var coreDataManager: CoreDataProtocol!
    var delegate: HomeViewControllerDelegate?
    var cells = [BasicCollectionViewCell]()
    
    private let currentHour = Calendar.current.component(.hour, from: Date())
    var didFetchData: (Int, Bool) -> () = { _,_ in }
    
    private var page = 1
    var articles: [ArticleData] = [] {
        didSet {
            articleCollectionView.reloadData()
            performBatchUpdates()
            //articleCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        coreDataManager = CoreDataManager.shared
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
                                               heightDimension: .estimated(40)))
        let localVerticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(400)),
            subitem: item, count: 3)
        let generalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(400)),
            subitems: [topItem, localVerticalGroup])
        generalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let section = NSCollectionLayoutSection(group: generalGroup)
        //section.visibleItemsInvalidationHandler
        section.interGroupSpacing = 80
        let layout = CustomFlowLayout(section: section, numberOfItemsInSection: 4)
        return layout
    }
    
    private func setupCollectionView() {
        articleCollectionView = UICollectionView(frame: .zero, collectionViewLayout:  createLayout())
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.prefetchDataSource = self
        articleCollectionView.isPrefetchingEnabled = true
        
        articleCollectionView.register(LargePortraitCell.self,
                                       forCellWithReuseIdentifier: LargePortraitCell.identifier)
        articleCollectionView.register(SmallCell.self, forCellWithReuseIdentifier: SmallCell.identifier)
        addSubview(articleCollectionView)
        articleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articleCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            articleCollectionView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        articleCollectionView.contentInset = UIEdgeInsets(top: 21, left: 0, bottom: 20, right: 0)
        articleCollectionView.backgroundColor = .clear
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(
            string: "Fetching more articles...",
            attributes: [NSAttributedString.Key.strokeColor : UIColor.black])
        articleCollectionView.refreshControl = refreshControl
    }
    
    @objc
    private func refresh(sender: UIRefreshControl) {
        didFetchData(1, true)
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
    
    func scrollToTop() {
        self.articleCollectionView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
    }
        
    private func performBatchUpdates() {
        let indexPath = IndexPath(item: self.articles.count - 1, section: 0)
        let indexPaths: [IndexPath] = [indexPath]
        articleCollectionView.performBatchUpdates({ () -> Void in
            articleCollectionView.insertItems(at: indexPaths)
        }, completion: nil)
    }
}

// MARK: - Collection View Data Source
extension ArticlesCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        guard let portraitCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: LargePortraitCell.identifier, for: indexPath)
                as? LargePortraitCell else { return cell }
        guard let smallCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SmallCell.identifier, for: indexPath)
                as? SmallCell else { return cell }
        let article = articles[indexPath.row]
        
        if indexPath.row % 4 == 0 {
            portraitCell.assignCellData(from: article, currentHour: currentHour)
            portraitCell.didShare = { [weak self] in
                guard let url = URL(string: article.url) else { return }
                self?.delegate?.presentShareSheet(url: url)
            }
            portraitCell.didSelected = { [weak self] in
                portraitCell.buttonSaving.isSelected ? print("delete") : self?.coreDataManager.createArticle(article)
            }
            cells.append(portraitCell)
            return portraitCell
        } else {
            smallCell.assignCellData(from: article, currentHour: currentHour)
            smallCell.didShare = { [weak self] in
                guard let url = URL(string: article.url) else { return }
                self?.delegate?.presentShareSheet(url: url)
            }
            cells.append(smallCell)
            return smallCell
        }
    }
}

// MARK: - Collection View Data Source Prefetching
extension ArticlesCollectionViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let filtered = indexPaths.filter({ $0.row >= articles.count - 1 })
        if filtered.count > 0 {
            page += 1
            self.didFetchData(page, false)
        }
    }
}

// MARK: - Collection View Delegate
extension ArticlesCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == articles.count - 1 {
//            page += 1
//            self.didFetchData(page, false)
//        }
    }
}
