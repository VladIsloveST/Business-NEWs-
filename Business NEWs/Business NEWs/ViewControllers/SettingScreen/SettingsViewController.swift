//
//  SettingsViewController.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

protocol TabBarControllerDelegate: AnyObject {
    func removeFromInactiveState()
}

class SettingsViewController: UIViewController {
    weak var delegate: TabBarControllerDelegate?
    weak var settingDelegate: SettingViewControllerDelegate?
    var themeManager: ThemeManagerProtocol!
    
    private let namesOfCells = [
        [("Thema", "moon"), ("Language", "globe"), ("Notification", "bell.badge")],
        [("Reviews", "exclamationmark.bubble"), ("About the App", "info.circle")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        themeManager = ThemeManager.shared
        adjustBottomSheet()
        setupTableView()
        setupNavBar()
    }
    
    private func adjustBottomSheet() {
        let sheet = self.sheetPresentationController
        sheet?.delegate = self
        sheet?.detents = [.medium()]
        sheet?.prefersGrabberVisible = true
        sheet?.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet?.largestUndimmedDetentIdentifier = .medium
        sheet?.preferredCornerRadius = 20
    }
    
    private func setupTableView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 75, width: view.bounds.width, height: view.bounds.height / 2), style: .insetGrouped)
        tableView.contentInset.top = -5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.separatorInset.right = 20
        tableView.separatorInset.left = 55
        view.addSubview(tableView)
    }
    
    private func setupNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 20, y: -30, width: view.bounds.width, height: 100))
        let navItem = UINavigationItem(title: "Settings".localized)
        navBar.items = [navItem]
        navBar.prefersLargeTitles = true
        view.addSubview(navBar)
    }
}

// MARK: - Table View Data Source
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        namesOfCells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        namesOfCells[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 1 ? "Support" : nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        let section = indexPath.section
        let text = namesOfCells[indexPath.section][indexPath.row].0
        let image = namesOfCells[indexPath.section][indexPath.row].1
        switch section {
        case 0:
            if indexPath.row == 0 {
                cell.setupSwitcher(isOn: self.themeManager.isDark)
                cell.didChangeTheme = { [weak self] isDark in
                    self?.themeManager.isDark = isDark
                    self?.settingDelegate?.changeThema()
                }
            }
            cell.configureUIElement(labelText: text, imageName: image, imageColor: .systemBlue)
        case 1:
            cell.configureUIElement(labelText: text, imageName: image, imageColor: .gray)
        default:
            break
        }
        return cell
    }
}

// MARK: - Table View Delegate 
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
        delegate?.removeFromInactiveState()
    }
}

// MARK: - Sheet Presentation Controller Delegate
extension SettingsViewController: UISheetPresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        delegate?.removeFromInactiveState()
    }
}

