//
//  HistoryCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 11.06.2023.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    static let identifier = HistoryTableViewCell.description()
    
    // MARK: - Private Properties
    var didDelete: UndefinedAction = {}
    var didRevert: UndefinedAction = {}
    private var searchLabel: UILabel!
    private let deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let revertButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.clockwise")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        searchLabel = UILabel()
        searchLabel.font = UIFont(name: "Helvetica Neue Medium", size: 18)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        revertButton.addTarget(self, action: #selector(didTapRevert), for: .touchUpInside)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(search text: String) {
        searchLabel.text = text
    }
    
    @objc
    private func didTapRevert() {
        didRevert()
    }
    
    @objc
    private func didTapDelete() {
        didDelete()
    }
    
    private func setupConstraints() {
        contentView.addSubview(deleteButton)
        contentView.addSubview(revertButton)
        contentView.addSubview(searchLabel)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        revertButton.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            
            revertButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            revertButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchLabel.leftAnchor.constraint(equalTo: revertButton.rightAnchor, constant: 10),
            searchLabel.rightAnchor.constraint(lessThanOrEqualTo: deleteButton.leftAnchor),
            searchLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
