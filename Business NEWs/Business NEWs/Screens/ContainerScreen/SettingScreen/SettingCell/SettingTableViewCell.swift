//
//  TableViewCell.swift
//  Business NEWs
//
//  Created by Mac on 16.07.2023.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier = SettingTableViewCell.description()
    
    // MARK: - Properties
    private var infoLabel = UILabel()
    private var infoImageView: UIImageView = {
        $0.contentMode = .center
        $0.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        $0.layer.cornerRadius = 7
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private var forwardImageView: UIImageView = {
        $0.tintColor = .lightGray
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        $0.image = image
        return $0
    }(UIImageView())
    
    var switcher: UISwitch!
    private var didChangeSetup: (Bool) -> () = { _ in }
    
    var languageToggle: UISegmentedControl!
    private var didChangeLanguage: (Int) -> () = { _ in }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
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
    
    func setupSwitcher(isOn: Bool, didChangeSetup: @escaping (Bool) -> () ) {
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
        switcher.addTarget(self, action: #selector(changeSetup), for: .valueChanged)
        switcher.onTintColor = .darkGray

        self.didChangeSetup = didChangeSetup
    }
    
    @objc private func changeSetup() {
        didChangeSetup(switcher.isOn)
    }
    
    func setupSegmentedControl(selected: Int, didChangeLanguage: @escaping (Int) -> () ) {
        let languages =  ["deutch", "english"]
        languageToggle = UISegmentedControl(items: languages)
        contentView.addSubview(languageToggle)
        languageToggle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            languageToggle.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            languageToggle.widthAnchor.constraint(equalToConstant: 150),
            languageToggle.heightAnchor.constraint(equalToConstant: 25),
            languageToggle.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        forwardImageView.isHidden = true
        languageToggle.selectedSegmentIndex = selected
        
        languageToggle.addTarget(self, action: #selector(changeLanguage), for: .valueChanged)
        languageToggle.backgroundColor = .lightGray

        self.didChangeLanguage = didChangeLanguage
    }
    
    @objc private func changeLanguage() {
        didChangeLanguage(languageToggle.selectedSegmentIndex)
    }
}
