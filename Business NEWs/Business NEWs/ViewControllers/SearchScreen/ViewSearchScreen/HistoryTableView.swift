//
//  HistoryCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 05.07.2023.
//

import UIKit

protocol PopOverTableViewProtocol: AnyObject {
    func selectItem(indexPath: IndexPath)
}

class HistoryTableView: UITableView {
    weak var mainCellDelegate: PopOverTableViewProtocol?
    
    private var flowLayout = UICollectionViewFlowLayout()
    private var cellConfigureArray = ["like", "subscribe", "contact", "like", "subscribe", "subscribe", "contact"]

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        flowLayout.minimumLineSpacing = 0
        register(HistoryCollectionViewCell.self, forCellReuseIdentifier: HistoryCollectionViewCell.identifier)
        separatorInset.right = 17
        layer.cornerRadius = 9
    }
}

// MARK: - Collection View Data Source
extension HistoryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigureArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCollectionViewCell.identifier, for: indexPath) as? HistoryCollectionViewCell else { return UITableViewCell() }
        cell.searchLabel.text = cellConfigureArray[indexPath.row]
        cell.didDelete = {
            self.cellConfigureArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            self.mainCellDelegate?.selectItem(indexPath: indexPath)
            self.reloadData()
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension HistoryTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


