//
//  MenuViewController.swift
//  Business NEWs
//
//  Created by Mac on 14.06.2023.
//

import UIKit

struct TestData {
    let name: String
    let data: Int
    
    init(name: String, data: Int) {
        self.name = name
        self.data = data
    }
}

enum MenuOptions: String, CaseIterable {
    case home = "Home"
    case info = "Information"
    case appRating = "App Rating"
    case shareApp = "ShareApp"
    case settings = "Settings"
    
    var image: String {
        switch self {
        case .home:
            return "house"
        case .info:
            return "airplane"
        case .appRating:
            return "star"
        case .shareApp:
            return "message"
        case .settings:
            return "gear"
        }
    }
}

struct Section {
    let title: String
    let options: [String]
    var isOpened = false
    
    init(title: String,
         options: [String],
         isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

protocol MenuViewControllerDelegate: AnyObject {
                            // MenuViewController.MenuOptions
    func didSelect(menuItem: String)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    private var sections = [Section]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    private let myLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = [
            Section(title: "Home", options: [1, 2].compactMap({ return "Cell \($0)" })),
            Section(title: "Information", options: [1, 2, 3, 4].compactMap({ return "Cell \($0)" })),
            Section(title: "App Rating", options: [1].compactMap({ return "Cell \($0)" })),
            Section(title: "ShareApp", options: [1, 2].compactMap({ return "Cell \($0)" })),
            Section(title: "Settings", options: [1, 2, 3].compactMap({ return "Cell \($0)" }))
        ]

        view.addSubview(tableView)
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        
        setupLable()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: myLabel.frame.origin.y + 30,
                                 width: view.bounds.size.width / 2.5,
                                 height: view.bounds.size.height)
    }
    
    private func setupLable() {
        myLabel.frame = CGRect(x: 20, y: 60, width: 50, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        myLabel.text = "Menu"
        view.addSubview(myLabel)
    }
}

// MARK: - Table View Data Source
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        return currentSection.isOpened ? (currentSection.options.count + 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].image)
        //        cell.imageView?.tintColor = .green
        //        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
        } else {
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
            cell.layoutMargins.left = 30
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
//          let item = MenuOptions.allCases[indexPath.row]
            let item = sections[indexPath.section].options[indexPath.row - 1]
            delegate?.didSelect(menuItem: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

