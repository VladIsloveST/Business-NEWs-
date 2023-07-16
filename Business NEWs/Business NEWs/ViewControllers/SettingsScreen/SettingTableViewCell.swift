//
//  TableViewCell.swift
//  Business NEWs
//
//  Created by Mac on 16.07.2023.
//

import UIKit
class SettingTableViewCell: UITableViewCell {
    static let idettifire = "SettingTableViewCell"
    
    private var infoLabel: UILabel!
    private var infoImageView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIElement(labelText: String, imageName: String, imageColor: UIColor) {
        infoLabel.text = labelText
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        infoImageView.image = image
        infoImageView.tintColor = .white
        infoImageView.backgroundColor = imageColor
    }
    
    private func setupUIElement() {
        infoLabel = UILabel()
        contentView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 59),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 20),
            infoLabel.widthAnchor.constraint(equalToConstant: frame.width - 20)
        ])
        
        infoImageView = UIImageView()
        contentView.addSubview(infoImageView)
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            infoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 30),
            infoImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        infoImageView.contentMode = .center
        infoImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        infoImageView.layer.cornerRadius = 7
        
        let forwardImageView = UIImageView()
        contentView.addSubview(forwardImageView)
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forwardImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            forwardImageView.widthAnchor.constraint(equalToConstant: 10),
            forwardImageView.heightAnchor.constraint(equalToConstant: 18),
            forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        forwardImageView.tintColor = .lightGray
        let forwardImage = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        forwardImageView.image = forwardImage
        addSubview(forwardImageView)
    }
}
