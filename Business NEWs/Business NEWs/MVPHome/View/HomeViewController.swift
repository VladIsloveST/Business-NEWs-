//
//  HomeViewController.swift
//  Business NEWs
//
//  Created by Mac on 10.02.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Public Properties
    
    @IBOutlet weak var newsCollectionView: UICollectionView! {
        didSet {
            newsCollectionView.dataSource = self
            newsCollectionView.delegate = self
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
// MARK: - Collection View Data Source

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
}

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    
}
