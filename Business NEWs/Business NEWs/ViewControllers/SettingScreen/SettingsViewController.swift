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

protocol SettingsDelegate: AnyObject {
    func setValueIsNotify()
}

class SettingsViewController: UIViewController {
    weak var delegate: TabBarControllerDelegate?
    weak var settingDelegateHome: SettingViewControllerDelegate?
    weak var settingDelegateSaved: SettingViewControllerDelegate?
    private var settingManager: SettingManagerProtocol!
    var localNotification: LocalNotificatioProtocol!
    
    private let namesOfCells = [
        [("Thema", "moon"), ("Language", "globe"), ("Notification", "bell.badge")],
        [("Reviews", "exclamationmark.bubble"), ("About the App", "info.circle")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingManager = SettingManager()
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
    
    private func showAlertCloseApp() {
        let message = "Changing your language requires that you exit Business NEWs.".localized
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Exit".localized , style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if self.settingManager.isNotify {
                let language = self.settingManager.language
                self.localNotification.reopenNotification(language: language)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    exit(0)
                }
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true)
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
        let text = namesOfCells[indexPath.section][indexPath.row].0.localized
        let image = namesOfCells[indexPath.section][indexPath.row].1
        if section == 0 {
            cell.configureUIElement(labelText: text, imageName: image, imageColor: .systemBlue)

            switch indexPath.row {
            case 0:
                cell.setupSwitcher(isOn: self.settingManager.isDark) { [weak self] isDark in
                    self?.settingManager.isDark = isDark
                    self?.settingDelegateHome?.changeThema()
                    self?.settingDelegateSaved?.changeThema()
                }
            case 1:
                let index = Language.allCases.firstIndex(of: settingManager.language) ?? 0
                cell.setupSegmentedControl(selected: index) { [weak self] selectedIndex in
                    self?.settingManager.language = Language.allCases[selectedIndex]
                    self?.showAlertCloseApp()
                }
            case 2:
                cell.setupSwitcher(isOn: self.settingManager.isNotify) { [weak self] isNotify in
                    self?.settingManager.isNotify = isNotify
                    if isNotify {
                        self?.localNotification.checkForPermission()
                        self?.localNotification.directToSettings { cell.switcher.isOn = false }
                    } else {
                        self?.localNotification.removeNotification()
                    }
                }
            default:
                break
            }
        } else {
            cell.configureUIElement(labelText: text, imageName: image, imageColor: .gray)
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

extension SettingsViewController: SettingsDelegate {
    func setValueIsNotify() {
        settingManager.isNotify = true
    }
}

