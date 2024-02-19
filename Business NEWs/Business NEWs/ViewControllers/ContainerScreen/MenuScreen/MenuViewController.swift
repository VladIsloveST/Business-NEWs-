//
//  MenuViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

enum MenuOptions: String {
    case home = "1.1"
    case info = "1.2"
    case appRating = "2.1"
    case shareApp = "3.1"
    case settings = "3.2"
    case homeTest = "3.3"
    case infoTest = "4.1"
    case appRatingTest = "5.1"
    case shareAppTest = "5.2"
}

struct Section {
    let title: String
    let options: [MenuOptions]
    var isOpened = false
    
    init(title: String, sectionOptions: [MenuOptions], isOpened: Bool = false) {
        self.title = title
        self.options = sectionOptions
        self.isOpened = isOpened
    }
}

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuOptions)
}

class MenuViewController: UIViewController {
    
    // MARK: -  Properties
    weak var delegate: MenuViewControllerDelegate?
    var size: CGFloat = 0
    private var menuSections: [Section] = []
    private var tableView: UITableView!
    private var menuLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTestName()
        setupLable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: menuLabel.frame.origin.y + 30,
                                 width: view.bounds.size.width / 2.5,
                                 height: view.bounds.size.height)
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.accessibilityIdentifier = "tableView"
        view.addSubview(tableView)
    }
    
    private func setupTestName() {
        menuSections = [
            Section(title: "1 row", sectionOptions: [MenuOptions.home, MenuOptions.info]),
            Section(title: "2 row", sectionOptions: [MenuOptions.appRating]),
            Section(title: "3 row", sectionOptions: [MenuOptions.shareApp, MenuOptions.settings, MenuOptions.homeTest]),
            Section(title: "4 row", sectionOptions: [MenuOptions.infoTest]),
            Section(title: "5 row", sectionOptions: [MenuOptions.appRatingTest, MenuOptions.shareAppTest])
        ]
    }
    
    private func setupLable() {
        menuLabel = UILabel()
        menuLabel.text = "Menu"
        menuLabel.frame = CGRect(x: 20, y: 60, width: 50, height: 20)
        menuLabel.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(menuLabel)
    }
}

// MARK: - Table View Data Source
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        menuSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = menuSections[section]
        return currentSection.isOpened ? (currentSection.options.count + 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = menuSections[indexPath.section].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: size)
        } else {
            cell.textLabel?.text = menuSections[indexPath.section].options[indexPath.row - 1].rawValue
            cell.textLabel?.font = UIFont(name: "Avenir Light Oblique", size: size)
            cell.layoutMargins.left = 30
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            menuSections[indexPath.section].isOpened = !menuSections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
            let item = menuSections[indexPath.section].options[indexPath.row - 1]
            delegate?.didSelect(menuItem: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

