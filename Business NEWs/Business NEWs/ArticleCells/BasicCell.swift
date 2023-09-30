//
//  BasicCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.07.2023.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
    
   
    var didShare: UndefinedAction = {}
    var didSelected: UndefinedAction = {}
    
    let buttonSaving: UIButton = {
        let button = UIButton(normalStateImage: "bookmark",
                              selectedStateImage: "bookmark.fill")
        button.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func tappedSelect() {
        didSelected()
        buttonSaving.isSelected = !buttonSaving.isSelected
    }
    
    private let buttonShare: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "square.and.arrow.up")
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchDown)
        return button
    }()
    
    @objc
    private func presentShareSheet() { didShare() }
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        label.textColor = .myTextColor
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var authorLable = UILabel()
    private var publishedLable = UILabel()
    
    private lazy var lableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.addArrangedSubview(authorLable)
        stackView.addArrangedSubview(publishedLable)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .center
        stackView.spacing = 23
        stackView.addArrangedSubview(buttonShare)
        stackView.addArrangedSubview(buttonSaving)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .center
        stackView.addArrangedSubview(lableStackView)
        stackView.addArrangedSubview(buttonStackView)
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(mainLabel)
        stackView.addArrangedSubview(horizontalStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView

    }()
    
    private var publicationDate = ""
    private var hoursAgo = 0
    var note = " • recently"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(generalStackView)
        setupColor()
        authorLable.font = UIFont(name: "Arial", size: (frame.size.width + 40) * 0.04)
        publishedLable.font = UIFont(name: "Arial", size: (frame.size.width + 40) * 0.04)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupColor() {
        backgroundColor = .cellBackgroundColor
        mainLabel.textColor = .myTextColor
        authorLable.textColor = .myTextColor
        publishedLable.textColor = .myTextColor
        buttonShare.tintColor = .myTextColor
        buttonSaving.tintColor = .myTextColor
    }
    
    func setLableFont() {
        mainLabel.font = UIFont(name: "Hiragino Mincho ProN W3", size: 20)
        authorLable.font = UIFont(name: "Arial", size: (frame.size.width + 40) * 0.04)
        publishedLable.font = UIFont(name: "Arial", size: (frame.size.width + 40) * 0.04)
    }
    
    func assignCellData(from article: ArticleData, currentHour: Int?) {
        mainLabel.text = article.title
        authorLable.text = article.author
        guard let currentHour = currentHour else { return }
        convertDateFormater(article.publishedAt, currentHour: currentHour)
    }
    
    func updatePublishedLabel() {
        note = hoursAgo > 1 ? " • \(hoursAgo) hours ago" : " • \(hoursAgo) hour ago"
        if hoursAgo == 24 { note = " • lately" }
        if hoursAgo == 0 { note = " • recently" }
        publishedLable.text = publicationDate + note
        if hoursAgo < 24 { hoursAgo += 1 }
    }
    
    private func convertDateFormater(_ date: String, currentHour: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let newDate = dateFormatter.date(from: date) else { return }
        let publicationHour = Calendar.current.component(.hour, from: newDate)
        hoursAgo = (currentHour >= publicationHour) ?
                            (currentHour - publicationHour) : (currentHour + 24 - publicationHour)
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        publicationDate = dateFormatter.string(from: newDate)
        updatePublishedLabel()
    }
}
