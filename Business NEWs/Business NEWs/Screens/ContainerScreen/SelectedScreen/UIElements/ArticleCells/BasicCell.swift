//
//  BasicCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.07.2023.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var publicationDate = ""
    private var hoursAgo = 24
    var note = " • recently"
    var didShare: UndefinedAction = {}
    var didSelecte: UndefinedAction = {}
    
    let buttonSaving: UIButton = {
        let button = UIButton(normalStateImage: "bookmark",
                              selectedStateImage: "bookmark.fill")
        button.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        return button
    }()
    
    private let buttonShare: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "square.and.arrow.up.fill")
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchUpInside)
        return button
    }()
    
    private var authorLable = UILabel()
    private var publishedLable = UILabel()
    private var mainLabel: UILabel = {
        $0.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        $0.textColor = .myTextColor
        $0.numberOfLines = 0
        $0.setLineSpacing(lineSpacing: 3)
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
   
    private lazy var lableStackView: UIStackView = {
        $0.axis = NSLayoutConstraint.Axis.vertical
        $0.alignment = .leading
        $0.spacing = 0
        $0.addArrangedSubview(authorLable)
        $0.addArrangedSubview(publishedLable)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var buttonStackView: UIStackView = {
        $0.axis = NSLayoutConstraint.Axis.horizontal
        $0.alignment = .center
        $0.spacing = 23
        $0.addArrangedSubview(buttonShare)
        $0.addArrangedSubview(buttonSaving)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = NSLayoutConstraint.Axis.horizontal
        $0.alignment = .center
        $0.addArrangedSubview(lableStackView)
        $0.addArrangedSubview(buttonStackView)
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    lazy var generalStackView: UIStackView = {
        $0.axis = NSLayoutConstraint.Axis.vertical
        $0.spacing = 10
        $0.addArrangedSubview(mainLabel)
        $0.addArrangedSubview(horizontalStackView)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    // MARK: - Initialization
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
    
    // MARK: - Methods
    @objc
    private func tappedSelect() {
        didSelecte()
        buttonSaving.isSelected = !buttonSaving.isSelected
    }
    
    @objc
    private func presentShareSheet() { didShare() }
    
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
    
    func assignCellData(from article: ArticleData, currentDate: DateComponents?, isSaved: Bool = false) {
        mainLabel.text = article.title
        authorLable.text = article.author
        guard let currentDate = currentDate else { return publishedLable.text = publicationDate }
        buttonSaving.isSelected = isSaved
        convertDateFormater(article.publishedAt, currentDate: currentDate)
    }
    
    
    func updatePublishedLabel() {
        note = hoursAgo > 1 ? " • \(hoursAgo) hours ago" : " • \(hoursAgo) hour ago"
        if hoursAgo >= 24 { note = " • lately" }
        if hoursAgo == 0 { note = " • recently" }
        publishedLable.text = publicationDate + note
        if hoursAgo < 24 { hoursAgo += 1 }
    }
    
    private func convertDateFormater(_ date: String, currentDate: DateComponents) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let newDate = dateFormatter.date(from: date) else { return }
        guard let currentHour = currentDate.hour,
              let currentDay = currentDate.day else { return }
        let publicationHour = Calendar.current.component(.hour, from: newDate)
        let publicationDay = Calendar.current.component(.day, from: newDate)
        if (currentDay - publicationDay) == 0  {
            hoursAgo = currentHour - publicationHour
        } else if (currentDay - publicationDay) == 1 {
            hoursAgo = currentHour + 24 - publicationHour
        }
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        publicationDate = dateFormatter.string(from: newDate)
        updatePublishedLabel()
    }
}
