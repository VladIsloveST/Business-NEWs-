//
//  SelectedArticlesViewController.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import UIKit
import Foundation

protocol HomeViewControllerMenuDelegate: AnyObject {
    func didTapMenuButton()
}

protocol HomeViewControllerDelegate: AnyObject {
    func presentShareSheet(url: URL)
}

protocol ArticlesMovementDelegate: AnyObject {
    func scrollToMenu(index: Int)
}

protocol SettingViewControllerDelegate: AnyObject {
    func changeThema()
}

class HomeViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: HomeViewControllerMenuDelegate?
    var presenter: ViewOutPut!
    var isFirstAppear = true
    
    private var moveToTop: UndefinedAction = {}
    private var changeThemaInCell: UndefinedAction = {} {
        didSet {
            changeThemaInCell()
        }
    }
    
    let articlesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.accessibilityIdentifier = "articlesCollectionView"
        collectionView.isPrefetchingEnabled = false
        return collectionView
    }()
    
    private var menuCollectionView: MenuCollectionView!
    private var loadingIndicator: ProgressView!
    private var topMenu: UIMenu!
    private var timer: Timer!
    var countOfItems = CategoriesOfArticles.allCases.count
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopMenu()
        setupMenu()
        setupNavBar()
        setupIndicator()
        setupCollectionView()
        notifyCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeThema() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear {
            Array(4...countOfItems - 1).forEach { index in
                presenter.getArticlesFromCategory(index: index, page: 1, isRefreshed: false)
            }
            isFirstAppear = false
        }
    }
    
    @objc
    func scrollToTop() {
        moveToTop()
    }
    
    private func setupCollectionView() {
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        articlesCollectionView.register(ArticlesCollectionViewCell.self,
                                        forCellWithReuseIdentifier: ArticlesCollectionViewCell.identifier)
        view.addSubview(articlesCollectionView)
        articlesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            articlesCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            articlesCollectionView.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor),
            articlesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        articlesCollectionView.isPagingEnabled = true
        articlesCollectionView.showsHorizontalScrollIndicator = false
        articlesCollectionView.bounces = false
    }
    
    private func setupMenu() {
        menuCollectionView = MenuCollectionView()
        view.addSubview(menuCollectionView)
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            menuCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        menuCollectionView.homeControllerDelegate = self
        menuCollectionView.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        //menuCollectionView.size = view.bounds.width / 22
    }
    
    private func setupIndicator() {
        loadingIndicator = ProgressView()
        articlesCollectionView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: articlesCollectionView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: articlesCollectionView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        loadingIndicator.isAnimating = true
    }
    
    private func setupNavBar() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollToTop))
        gestureRecognizer.numberOfTapsRequired = 1
        navigationController?.navigationBar.addGestureRecognizer(gestureRecognizer)
        navigationController?.navigationBar.backgroundColor = .white
        let menuButtonItem = UIBarButtonItem(
            imageSystemName: "line.horizontal.3", target: self, action: #selector(didTapMenuButton))
        let searchBarButtonItem = UIBarButtonItem(
            imageSystemName: "magnifyingglass", target: self, action: #selector(didTapSearchButton))
        let moreButtonItem = UIBarButtonItem(
            imageSystemName: "ellipsis", target: self, menu: topMenu)
        moreButtonItem.customView?.transform = CGAffineTransform(rotationAngle: .pi / 2)
        navigationItem.leftBarButtonItem = menuButtonItem
        navigationItem.rightBarButtonItems = [moreButtonItem, searchBarButtonItem]
        navigationItem.title = "Home".localized
    }
    
    @objc
    private func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
    @objc
    private func didTapSearchButton() {
        presenter.tapOnTheSearch()
    }
    
    private func setupTopMenu() {
        topMenu = UIMenu()
        let copy =  UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc"),
                             handler: { _ in print("copy") })
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"),
                             handler: { _ in print("Share") })
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"),attributes: .destructive ,
                              handler: { _ in print("Delete") })
        topMenu = UIMenu(title: "Options", options: .displayInline, children: [copy, share, delete])
    }
    
    private func notifyCells() {
        let visibleCells = articlesCollectionView.visibleCells
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            if visibleCells.isEmpty { self?.timer.invalidate() }
            visibleCells.forEach({ cell in
                (cell as? ArticlesCollectionViewCell)?.articleCollectionView.visibleCells.filter {
                    ($0 as? BasicCollectionViewCell)?.note != " • lately" }.forEach { cell in
                        (cell as? BasicCollectionViewCell)?.updatePublishedLabel()
                    }
            })
        }
    }
}

// MARK: - Table View Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell",
                                                                    for: indexPath)
                as? ArticlesCollectionViewCell else { return UICollectionViewCell() }
        moveToTop = { cell.scrollToTop() }
        changeThemaInCell = { cell.cells.forEach{ $0.setupColor() } }
        
        if !presenter.typesOfArticles.isEmpty {
            cell.delegate = self
            let articles = presenter.typesOfArticles[indexPath.row]
            cell.articles = articles
            cell.didFetchData = { [weak self] (page, isRefreshed) in
                self?.presenter
                    .getArticlesFromCategory(index: indexPath.row, page: page, isRefreshed: isRefreshed)
            }
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        menuCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        menuCollectionView.animateMovementUnderlineView(item: indexPath.item)
    }
}

// MARK: - Collection View Delegate Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension HomeViewController: ViewInPut {
    func success() {
        loadingIndicator.isAnimating = false
        self.view.isUserInteractionEnabled = true
        articlesCollectionView.reloadData()
    }
    
    func failer(error: NetworkError) {
        //self.navigationItem.rightBarButtonItems?.last?.isEnabled = false
        DispatchQueue.main.async {
            self.showAlertWith(message: error.rawValue)
        }
    }
}

extension HomeViewController: ArticlesMovementDelegate {
    func scrollToMenu(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        articlesCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    func presentShareSheet(url: URL) {
        DispatchQueue.main.async {
            let activityViewPopover = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityViewPopover, animated: true)
        }
    }
}


// MARK: - Change color
extension HomeViewController: SettingViewControllerDelegate {
    func changeThema() {
        articlesCollectionView.backgroundColor = .myBackgroundColor
        changeThemaInCell()
    }
}
