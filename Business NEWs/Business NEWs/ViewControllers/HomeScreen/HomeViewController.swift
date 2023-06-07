//
//  SelectedArticlesViewController.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
    private let menuCollectionView = MenuCollectionView()
    
    var presenter: ViewOutPut!
    
    lazy var activityIndicatory: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.frame = CGRect(x: view.center.x - 25,
                                    y: view.center.y - 50,
                                    width: 50,
                                    height: 50)
        view.addSubview(activityView)
        view.isUserInteractionEnabled = false
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //articlesTableView.bounces = false
        
        articlesTableView.contentInset.top = 61
        articlesTableView.horizontalScrollIndicatorInsets.top = 60
        
        activityIndicatory.startAnimating()
        setupMenu()
        setupNavBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Home"
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
        
    }
    
    @objc func handleSearch() {
        let searchViewController = SearchViewController()
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @objc func handleMore() {
        print(321)
    }
    
    private func setupMenu() {
        view.addSubview(menuCollectionView)
        
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            menuCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            menuCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articlesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let article = presenter.articles?.articles[indexPath.row]
        cell.textLabel?.text = article?.title
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        print(text)
    }
}

extension HomeViewController: ViewInPut {
    func success() {
        self.activityIndicatory.stopAnimating()
        self.view.isUserInteractionEnabled = true
        articlesTableView.reloadData()
    }
    
    func failer(error: Error) {
        print(error.localizedDescription)
    }
}
