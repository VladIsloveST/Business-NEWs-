//
//  SelectedArticlesViewController.swift
//  Business NEWs
//
//  Created by Mac on 06.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var articlesTableView: UITableView!
    
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
    
    var presenter: ViewOutPut!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatory.startAnimating()
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
