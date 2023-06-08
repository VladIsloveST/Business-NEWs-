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
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articlesTableView.bounces = false
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        articlesTableView.contentInset.top = 70
        articlesTableView.horizontalScrollIndicatorInsets.top = 60
        
        loadingIndicator.isAnimating = true
        
        setupMenu()
        setupNavBarButtons()
        setupIndicatot()
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
            menuCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            
            menuCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            menuCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
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
        loadingIndicator.isAnimating = false
        self.view.isUserInteractionEnabled = true
        articlesTableView.reloadData()
    }
    
    func failer(error: Error) {
        print(error.localizedDescription)
    }
}
