//
//  TableViewCell.swift
//  Business NEWs
//
//  Created by Mac on 16.07.2023.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let idettifire = "SettingTableViewCell"
    private var infoLabel = UILabel()
    private var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        imageView.layer.cornerRadius = 7
        imageView.tintColor = .white
        return imageView
    }()
    
    private var forwardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        imageView.image = image
        return imageView
    }()
    
    private var switcher: UISwitch!
    var didChangeTheme: (Bool) -> () = { _ in }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(infoLabel)
        contentView.addSubview(infoImageView)
        contentView.addSubview(forwardImageView)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        forwardImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 59),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 20),
            infoLabel.widthAnchor.constraint(equalToConstant: frame.width - 20),
            
            infoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            infoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 30),
            infoImageView.widthAnchor.constraint(equalToConstant: 30),
            
            forwardImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            forwardImageView.widthAnchor.constraint(equalToConstant: 10),
            forwardImageView.heightAnchor.constraint(equalToConstant: 18),
            forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureUIElement(labelText: String, imageName: String, imageColor: UIColor) {
        infoLabel.text = labelText
        let configuration = UIImage.SymbolConfiguration(weight: .regular)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        infoImageView.image = image
        infoImageView.backgroundColor = imageColor
    }
    
    func setupSwitcher(isOn: Bool) {
        switcher = UISwitch()
        let centerYAnchorConstant = (switcher.frame.height - frame.height) / 2
        contentView.addSubview(switcher)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switcher.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            switcher.widthAnchor.constraint(equalToConstant: 40),
            switcher.heightAnchor.constraint(equalToConstant: 18),
            switcher.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYAnchorConstant)
        ])
        forwardImageView.isHidden = true
        switcher.isOn = isOn
        switcher.becomeFirstResponder()
        switcher.addTarget(self, action: #selector(changeColor), for: .valueChanged)
        switcher.onTintColor = .darkGray
    }
    
    @objc private func changeColor() {
        didChangeTheme(switcher.isOn)
    }
}
