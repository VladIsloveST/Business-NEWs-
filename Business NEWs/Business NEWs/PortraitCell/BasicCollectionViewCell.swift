//
//  BasicCollectionViewCell.swift
//  Business NEWs
//
//  Created by Mac on 07.07.2023.
//

import UIKit

class BasicCollectionViewCell: UICollectionViewCell {
        
    var timer: Timer?
    let calendar = Calendar.current
    var didShare: () -> () = {}
    
    let buttonSaving: UIButton = {
        let button = UIButton(normalStateImage: "bookmark",
                           selectedStateImage: "bookmark.fill")
        button.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func tappedSelect() {
        switch buttonSaving.isSelected {
        case true:
            print("Not Selected")
            return buttonSaving.isSelected = false
        case false:
            print("Selected")
            return buttonSaving.isSelected = true
        }
    }
    
    let buttonShare: UIButton = {
        let button = UIButton(normalStateImage: "square.and.arrow.up",
                              selectedStateImage: "square.and.arrow.up")
        button.addTarget(self, action: #selector(presentShareSheet), for: .touchDown)
        return button
    }()
    
    @objc
    private func presentShareSheet() {
        didShare()
    }
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hiragino Mincho ProN W6", size: 20)
        label.textColor = .white
        label.text = "Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium. Helvetica Neue Medium."
        label.numberOfLines = 0
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .left
        return label
    }()
    
    var authorLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "Artiane de Vogue"
        return label
    }()
    
    private var publishedAtLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 16)
        label.textColor = .white
        label.text = "1h ago"
        return label
    }()
    
    lazy var lableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.addArrangedSubview(authorLable)
        stackView.addArrangedSubview(publishedAtLable)
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
        addSubview(mainLabel)
        addSubview(buttonStackView)
        addSubview(lableStackView)
        backgroundColor = .darkGray
        
        buttonStackView.addArrangedSubview(buttonShare)
        buttonStackView.addArrangedSubview(buttonSaving)
        lableStackView.addArrangedSubview(authorLable)
        lableStackView.addArrangedSubview(publishedAtLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func convertDateFormater(_ date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let newDate = dateFormatter.date(from: date) else { return }
        
        let minute = calendar.component(.minute, from: newDate)
        let hour = calendar.component(.hour, from: newDate)
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let fixedDate = dateFormatter.string(from: newDate)
        
        setup(fixedDate: fixedDate, publicationHour: hour, publicationMinute: minute)
    }
    
    private func setup(fixedDate: String, publicationHour: Int, publicationMinute: Int) {
        let currentDate = getCurrentDate()
        let hourAgo = (currentDate.hour >= publicationHour) ? (currentDate.hour - publicationHour) : (currentDate.hour + 24 - publicationHour)
        var minAgo = (hourAgo * 60 + currentDate.minute) - publicationMinute
        // дубляж
        var note = (minAgo <= 59) ? "\(minAgo) min" : "\(hourAgo) hour"
        if hourAgo > 1 { note += "s" }
        self.publishedAtLable.text = fixedDate + " • \(note) ago"

        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            if minAgo == 779 {
                self?.timer?.invalidate()
                self?.publishedAtLable.text = fixedDate
                return
            }
            minAgo += 1
            var note = (minAgo <= 59) ? "\(minAgo) min" : "\(minAgo/60) hour"
            if minAgo/60 > 1 { note += "s" }
            self?.publishedAtLable.text = fixedDate + " • \(note) ago"
        }
    }
    
    private func getCurrentDate() -> (hour: Int, minute: Int) {
        let date = Date()
        let currentHour = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)
        return (currentHour, currentMinute)
    }
}
