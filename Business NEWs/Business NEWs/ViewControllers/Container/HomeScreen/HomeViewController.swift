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

protocol HomeViewControllerShareDelegate: AnyObject {
    func presentShareSheet(url: URL)
}

protocol ArticlesMovementDelegate: AnyObject {
    func scrollToMenu(index: Int)
}

class HomeViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: HomeViewControllerDelegate?
    var presenter: ViewOutPut!
    
    private var moveToTop: () -> () = {}
    private let articlesCollectionView: UICollectionView = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopMenu()
        setupMenu()
        setupNavBar()
        setupIndicator()
        setupCollectionView()
        loadingIndicator.isAnimating = true
    }
    
    @objc
    func scrollToTop() {
        moveToTop()
    }
    
    private func setupCollectionView() {
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        articlesCollectionView.register(ArticleCollectionViewCell.self,
                                        forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
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
        navigationItem.title = "Home"
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
}

// MARK: - Table View Data Source
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = articlesCollectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        moveToTop = { cell.scrollToTop() }
        if !presenter.typesOfArticles.isEmpty {
            let articlesOfTheSamePublisher = presenter.typesOfArticles[indexPath.row]
            cell.delegat = self
            cell.articles = articlesOfTheSamePublisher
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
    
    func failer(error: Error) {
        DispatchQueue.main.async {
            self.showAlert("Error", message: error.localizedDescription)
        }
    }
}

extension HomeViewController: ArticlesMovementDelegate {
    func scrollToMenu(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        articlesCollectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}

extension HomeViewController: HomeViewControllerShareDelegate {
    func presentShareSheet(url: URL) {
        DispatchQueue.main.async {
            let activityViewPopover = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.present(activityViewPopover, animated: true)
        }
    }
}
