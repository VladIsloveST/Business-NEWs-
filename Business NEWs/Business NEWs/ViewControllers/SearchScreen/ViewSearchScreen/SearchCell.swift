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
    var didRevert: () -> () = {}
    
    let searchLabel = UILabel()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        revertButton.addTarget(self, action: #selector(didTapRevert), for: .touchUpInside)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapRevert() {
        print("didTapRevert")
        didRevert()
    }
    
    @objc
    private func didTapDelete() {
        print("didTapDelete")
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
            deleteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25),
            deleteButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            
            revertButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            revertButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            searchLabel.leftAnchor.constraint(equalTo: revertButton.rightAnchor, constant: 10),
            searchLabel.rightAnchor.constraint(lessThanOrEqualTo: deleteButton.leftAnchor),
            searchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
