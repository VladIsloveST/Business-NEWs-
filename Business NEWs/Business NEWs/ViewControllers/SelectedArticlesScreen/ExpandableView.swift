//
//  ExpandableView.swift
//  Business NEWs
//
//  Created by Mac on 03.07.2023.
//

import Foundation
import UIKit

class ExpandableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
