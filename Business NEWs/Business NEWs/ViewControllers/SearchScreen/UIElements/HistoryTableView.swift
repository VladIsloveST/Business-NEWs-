//
//  HistoryCollectionView.swift
//  Business NEWs
//
//  Created by Mac on 05.07.2023.
//

import UIKit

protocol PopOverTableViewDelegate: AnyObject {
    func selectItem(row: Int, with action: Action)
}

enum Action {
    case delete
    case revert
    case search
}

class HistoryTableView: UITableView {
    weak var mainCellDelegate: PopOverTableViewDelegate?
    
    private var flowLayout = UICollectionViewFlowLayout()
    
    var mockData = ["Built environments", "are where", "humans have", "fundamentally", "transformed landscapes", "such as urban", "settings"]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func added(item: String) {
        mockData.insert(item, at: 0)
        if mockData.count > 10 {
            mockData.removeLast()
        }
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        flowLayout.minimumLineSpacing = 0
        register(HistoryTableViewCell.self,
                 forCellReuseIdentifier: HistoryTableViewCell.identifier)
        separatorInset.right = 17
        layer.cornerRadius = 9
    }
}

// MARK: - Collection View Data Source
extension HistoryTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(mockData.count)
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        cell.searchLabel.text = mockData[indexPath.row]
        cell.didDelete = {
            self.mockData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            self.mainCellDelegate?.selectItem(row: indexPath.row, with: .delete)
            self.reloadData()
        }
        cell.didRevert = {
            self.mainCellDelegate?.selectItem(row: indexPath.row, with: .revert)
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension HistoryTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainCellDelegate?.selectItem(row: indexPath.row, with: .search)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
