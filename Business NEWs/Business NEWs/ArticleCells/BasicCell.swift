//
//  BasicCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.07.2023.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
        
    var didShare: () -> () = {}
    var didSelected: () -> () = {}
    
    let buttonSaving: UIButton = {
        let button = UIButton(normalStateImage: "bookmark",
                              selectedStateImage: "bookmark.fill")
        button.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        button.tintColor = .myTextColor
        return button
    }()
    
    private var publicationDate = ""
    private var hoursAgo = 0
    var note = " • recently"
    
    @objc
    private func tappedSelect() {
        switch buttonSaving.isSelected {
        case true:
            print("Not Selected")
            didSelected()
            return buttonSaving.isSelected = false
        case false:
            print("Selected")
            didSelected()
            return buttonSaving.isSelected = true
        }
    }
    
    let buttonShare: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "square.and.arrow.up")
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchDown)
        button.tintColor = .myTextColor
        button.becomeFirstResponder()
        return button
    }()
    
    @objc
    private func presentShareSheet() {
        didShare()
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        label.textColor = .myTextColor
        label.text = "Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium."
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .left
        return label
    }()
    
    var authorLable = UILabel()
    var publishedLable = UILabel()
    
    lazy var lableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.addArrangedSubview(authorLable)
        stackView.addArrangedSubview(publishedLable)
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .center
        stackView.spacing = 23
        stackView.addArrangedSubview(buttonShare)
        stackView.addArrangedSubview(buttonSaving)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //coreDataManager = CoreDataManager.shared
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        backgroundColor = .cellBackgroundColor
        
        buttonStackView.addArrangedSubview(buttonShare)
        buttonStackView.addArrangedSubview(buttonSaving)
        lableStackView.addArrangedSubview(authorLable)
        lableStackView.addArrangedSubview(publishedLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLableStackWith(size: CGFloat) {
        authorLable.font = UIFont(name: "Arial", size: size)
        authorLable.textColor = .myTextColor
        publishedLable.font = UIFont(name: "Arial", size: size)
        publishedLable.textColor = .myTextColor
    }
    
    func setupLableTextColor() {
        authorLable.textColor = .myTextColor
        publishedLable.textColor = .myTextColor
        mainLabel.textColor = .myTextColor
//        buttonShare.tintColor = .myTextColor
//        buttonSaving.tintColor = .myTextColor
    }
    
    func convertDateFormater(_ date: String, currentHour: Int) {
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
    
    func updatePublishedLabel() {
        note = hoursAgo > 1 ? " • \(hoursAgo) hours ago" : " • \(hoursAgo) hour ago"
        if hoursAgo == 24 { note = " • lately" }
        if hoursAgo == 0 { note = " • recently" }
        publishedLable.text = publicationDate + note
        if hoursAgo < 24 { hoursAgo += 1 }
    }
}
