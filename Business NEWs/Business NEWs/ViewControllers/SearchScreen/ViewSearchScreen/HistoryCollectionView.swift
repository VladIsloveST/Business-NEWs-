//
//  HistoryCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 05.07.2023.
//

import UIKit

protocol PopOverCollectionViewProtocol: AnyObject {
    func selectItem(indexPath: IndexPath)
}

class HistoryCollectionView: UICollectionView {

    weak var mainCellDelegate: PopOverCollectionViewProtocol?
    
    private var flowLayout = UICollectionViewFlowLayout()
    var cellConfigureArray = ["like", "subscribe", "contact"]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super .init(frame: .zero, collectionViewLayout: flowLayout)
        configure()
        
        flowLayout.minimumLineSpacing = 0
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        print(contentSize.height)
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        
        register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: HistoryCollectionViewCell.identifier)
    }
}

// MARK: - Collection View Data Source
extension HistoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellConfigureArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryCollectionViewCell.identifier, for: indexPath) as? HistoryCollectionViewCell else { return UICollectionViewCell() }
        cell.searchLabel.text = cellConfigureArray[indexPath.row]
        cell.didDelete = { self.cellConfigureArray.remove(at: indexPath.row)
            self.reloadData()
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension HistoryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainCellDelegate?.selectItem(indexPath: indexPath)
    }
}

// MARK: - Collection View Delegate Flow Layout
extension HistoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }
}

