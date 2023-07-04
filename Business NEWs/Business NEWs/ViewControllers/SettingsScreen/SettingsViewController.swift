//
//  SettingsViewController.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        adjustBottomSheet()
    }
    
    private func adjustBottomSheet() {
        let sheet = self.sheetPresentationController
        sheet?.detents = [.medium(), .large()]
        sheet?.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet?.prefersGrabberVisible = true
        sheet?.largestUndimmedDetentIdentifier = .medium
        sheet?.preferredCornerRadius = 20
    }
}
