//
//  SettingsViewController.swift
//  Business NEWs
//
//  Created by Mac on 13.06.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let namesOfCells = [
        [("Thema", "moon"), ("Language", "globe"), ("Notification", "bell.badge")],
        [("Reviews", "exclamationmark.bubble"), ("About the App", "info.circle")]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        adjustBottomSheet()
        setupTableView()
        setupNavBar()
    }
    
    private func adjustBottomSheet() {
        let sheet = self.sheetPresentationController
        sheet?.detents = [.medium()]
        sheet?.prefersScrollingExpandsWhenScrolledToEdge = false
        sheet?.prefersGrabberVisible = true
        sheet?.largestUndimmedDetentIdentifier = .medium
        sheet?.preferredCornerRadius = 20
    }
    
    private func setupTableView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: view.bounds.height / 2), style: .insetGrouped)
        tableView.contentInset.top = -5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.idettifire)
        tableView.separatorInset.right = 20
        tableView.separatorInset.left = 55
        view.addSubview(tableView)
    }
    
    private func setupNavBar() {
        let navBar = UINavigationBar(frame: CGRect(x: 20, y: -30, width: view.bounds.width, height: 100))
        let navItem = UINavigationItem(title: "Settings")
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.idettifire, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        let section = indexPath.section
        let text = namesOfCells[indexPath.section][indexPath.row].0
        let image = namesOfCells[indexPath.section][indexPath.row].1
        switch section {
        case 0:
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
    }
}

