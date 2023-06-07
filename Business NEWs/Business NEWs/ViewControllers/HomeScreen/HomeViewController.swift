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
        
        articlesTableView.contentInset.top = 61
        articlesTableView.horizontalScrollIndicatorInsets.top = 60
        
        activityIndicatory.startAnimating()
        //searchBar.delegate = self
        setupMenu()
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
