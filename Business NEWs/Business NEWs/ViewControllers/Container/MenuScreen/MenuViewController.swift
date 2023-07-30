//
//  MenuViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

enum MenuOptions: String {
    case home = "Home"
    case info = "Information"
    case appRating = "App Rating"
    case shareApp = "ShareApp"
    case settings = "Settings"
    case homeTest = "HomeTest"
    case infoTest = "InformationTest"
    case appRatingTest = "App RatingTest"
    case shareAppTest = "ShareAppTest"
}

struct Section {
    let title: String
    let options: [MenuOptions]
    var isOpened = false
    
    init(title: String,
         sectionOptions: [MenuOptions],
         isOpened: Bool = false) {
        self.title = title
        self.options = sectionOptions
        self.isOpened = isOpened
    }
}

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuOptions)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    private var menuSections: [Section] = []
    private var tableView: UITableView!
    private var menuLabel: UILabel!
    
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
            Section(title: "Home", sectionOptions: [MenuOptions.appRating, MenuOptions.home]),
            Section(title: "Information", sectionOptions: [MenuOptions.info]),
            Section(title: "App Rating", sectionOptions: [MenuOptions.homeTest]),
            Section(title: "ShareApp", sectionOptions: [MenuOptions.infoTest, MenuOptions.shareAppTest, MenuOptions.appRatingTest]),
            Section(title: "Settings", sectionOptions: [MenuOptions.shareApp, MenuOptions.settings])
        ]
    }
    
    private func setupLable() {
        menuLabel = UILabel()
        menuLabel.frame = CGRect(x: 20, y: 60, width: 50, height: 20)
        menuLabel.font = UIFont.boldSystemFont(ofSize: 18)
        menuLabel.text = "Menu"
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        } else {
            cell.textLabel?.text = menuSections[indexPath.section].options[indexPath.row - 1].rawValue
            cell.textLabel?.font = UIFont(name: "Avenir Light Oblique", size: 17)
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

