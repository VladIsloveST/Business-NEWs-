//
//  SelectedArticlesViewController.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    var presenter: ViewOutPut!
    lazy private var menuCollectionView: MenuCollectionView = {
        let menuBar = MenuCollectionView()
        menuBar.homeController = self
        return menuBar
    }()
    
    private let loadingIndicator: ProgressView = {
        let progress = ProgressView(lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        articlesCollectionView.bounces = false
        articlesCollectionView.contentInset.top = 70
        articlesCollectionView.horizontalScrollIndicatorInsets.top = 60
        
        loadingIndicator.isAnimating = true
        
        setupMenu()
        setupNavBarButtons()
        setupIndicatot()
        setupCollectionView()
    }
    
    private func  setupCollectionView() {
        
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        articlesCollectionView.register(
            UINib(nibName: "ArticleCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        articlesCollectionView.isPagingEnabled = true
        
        if let flowLayoutm = articlesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayoutm.scrollDirection = .horizontal
            flowLayoutm.minimumLineSpacing = 0
        }
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreImage = UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysOriginal)
        let moreButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButtonItem, searchBarButtonItem]
    
        let menuImage = UIImage(systemName: "line.horizontal.3")?.withRenderingMode(.alwaysOriginal)
        let menuButtonItem = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    @objc func handleMenu() {
        print("Menu")
    }
    
    @objc func handleSearch() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func handleMore() {
       // scrollToMenu(index: 2)
    }
    
    func scrollToMenu(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        articlesCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    
    private func setupIndicatot() {
        view.addSubview(loadingIndicator)
        
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
        view.addSubview(menuCollectionView)
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor
                .constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
                            multiplier: 0),
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
        
        
        guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        
        let colorArray: [UIColor] = [.lightGray, .yellow, .systemPink, .orange]
        cell.backgroundColor = colorArray[indexPath.row]
        return cell
        
//        let typesOfArticles = presenter.typesOfArticles[indexPath.section]
//        switch typesOfArticles {
//        case .apple(let appleType):
//            let apple = appleType.articles[indexPath.row]
//            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
//            cell.articlesLabel.text = apple.title
//            return cell
//
//        case .business(let businessType):
//            let business = businessType.articles[indexPath.row]
//            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
//            cell.articlesLabel.text = business.title
//            return cell
//
//        case .techCrunch(let techCrunchType):
//            let techCrunch = techCrunchType.articles[indexPath.row]
//            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
//            cell.articlesLabel.text = techCrunch.title
//            return cell
//        default: return UICollectionViewCell()

//        case .wallStreet(let wallStreetType):
//            let wallStreet = wallStreetType.articles[indexPath.row]
//            guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
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
}

// MARK: - Collection View Delegate Flow Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - Search Bar Delegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        print(text)
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
