//
//  SearchCell.swift
//  Business NEWs
//
//  Created by Mac on 11.06.2023.
//

import Foundation
import UIKit


class SearchCell: UITableViewCell {
    
    var didDelete: () -> () = {}
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapDelete() {
        print("didTapDelete")
        didDelete()
    }
    
    private func setupButton() {
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
