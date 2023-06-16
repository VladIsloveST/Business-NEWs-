//
//  SelectedArticlesViewController.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    var presenter: ViewOutPut!
    
    private let menuCollectionView = MenuCollectionView()
    private let loadingIndicator = ProgressView()
    private let articlesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let colView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return colView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.isAnimating = true
        
        setupMenu()
        setupNavBarButtons()
        setupIndicatot()
        setupCollectionView()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func  setupCollectionView() {
        
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        articlesCollectionView.register(
            UINib(nibName: ArticleCollectionViewCell.identifier , bundle: nil),
            forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
        
        articlesCollectionView.isPagingEnabled = true
        articlesCollectionView.showsHorizontalScrollIndicator = false
        articlesCollectionView.bounces = false
        
        view.addSubview(articlesCollectionView)
        articlesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            articlesCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            articlesCollectionView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor),
            articlesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setupNavBarButtons() {
        let searchBarButtonItem = UIBarButtonItem(
            imageSystemName: "magnifyingglass", target: self, action: #selector(didTapSearchButton))
        let moreButtonItem = UIBarButtonItem(
            imageSystemName: "ellipsis",target: self, action: #selector(didTapMoreButton))
        navigationItem.rightBarButtonItems = [moreButtonItem, searchBarButtonItem]
        
        let menuButtonItem = UIBarButtonItem(
            imageSystemName: "line.horizontal.3", target: self, action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
    @objc func didTapSearchButton() {
        let searchViewController = ModuleBuilder.createSearchBuilder()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func didTapMoreButton() {
        print("More")
    }
    
    func scrollToMenu(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        articlesCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    private func setupIndicatot() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor
                .constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor
                .constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    private func setupMenu() {
        menuCollectionView.homeController = self
        
        view.addSubview(menuCollectionView)
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor
                .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.widthAnchor
                .constraint(equalToConstant: view.frame.width),
            menuCollectionView.heightAnchor
                .constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Table View Data Source

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //presenter.typesOfArticles.count
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //presenter.typesOfArticles[section].numberOfArticles
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        let articlesOfTheSamePublisher = presenter.typesOfArticles[indexPath.section].articlesOfTheSamePublisher
        //        let article = articlesOfTheSamePublisher[indexPath.row]
        //        guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        //        cell.articlesLabel.text = article.title
        //        return cell
        
        guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        
        let colorArray: [UIColor] = [.lightGray, .yellow, .systemPink, .orange]
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
        
        //        let typesOfArticles = presenter.typesOfArticles[indexPath.section]
        //        switch typesOfArticles {
        //        case .apple(let appleType):
        //            let apple = appleType.articles[indexPath.row]
        //            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        //            cell.articlesLabel.text = apple.title
        //            return cell
        //
        //        case .business(let businessType):
        //            let business = businessType.articles[indexPath.row]
        //            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        //            cell.articlesLabel.text = business.title
        //            return cell
        //
        //        case .techCrunch(let techCrunchType):
        //            let techCrunch = techCrunchType.articles[indexPath.row]
        //            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        //            cell.articlesLabel.text = techCrunch.title
        //            return cell
        //
        //        case .wallStreet(let wallStreetType):
        //            let wallStreet = wallStreetType.articles[indexPath.row]
        //            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        //            cell.articlesLabel.text = wallStreet.title
        //            return cell
        //        }
    }
}

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuCollectionView.leftAnchorConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

// MARK: - Collection View Delegate Flow Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension HomeViewController: ViewInPut {
    func success() {
        loadingIndicator.isAnimating = false
        self.view.isUserInteractionEnabled = true
        articlesCollectionView.reloadData()
    }
    
    func failer(error: Error) {
        print(error.localizedDescription)
    }
}
