//
//  MenuViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

enum MenuOptions: String {
    case business
    case health
    case science
    case sports
    case technology
    case relevancy
    case popularity
    case today
    case yesterday
    case week
    case month
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
    private static let cellReuseIdentifier = "menuCell"
    
    // MARK: -  Properties
    weak var delegate: MenuViewControllerDelegate?
    private var size: CGFloat
    private var menuSections: [Section] = []
    private var tableView: UITableView!
    private var menuLabel: UILabel!
    
    // MARK: - Initialization
    init(size: CGFloat) {
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MenuViewController.cellReuseIdentifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    private func setupTestName() {
        menuSections = [
            Section(title: "◦ category", sectionOptions: [MenuOptions.business,
                                                        MenuOptions.health, MenuOptions.science,
                                                        MenuOptions.sports, MenuOptions.technology]),
            Section(title: "◦ sort by", sectionOptions: [MenuOptions.relevancy, MenuOptions.popularity]),
            Section(title: "◦ published", sectionOptions: [MenuOptions.today, MenuOptions.yesterday,
                                                                     MenuOptions.week, MenuOptions.month])
        ]
    }
    
    private func setupLable() {
        menuLabel = UILabel()
        menuLabel.text = "Menu"
        menuLabel.frame = CGRect(x: 20, y: 60, width: 51, height: 20)
        menuLabel.font = UIFont.boldSystemFont(ofSize: 19.5)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuViewController.cellReuseIdentifier,
                                                 for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = menuSections[indexPath.section].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: size)
        } else {
            cell.textLabel?.text = menuSections[indexPath.section].options[indexPath.row - 1].rawValue
            cell.textLabel?.font = UIFont(name: "Avenir Light Oblique", size: size - 0.5)
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

