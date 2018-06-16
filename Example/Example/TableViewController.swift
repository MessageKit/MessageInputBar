//
//  TableViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2018-06-15.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import UIKit

final class TableViewController: UITableViewController {
    
    let styles: [MessageInputBarStyle] = [.default, .imessage, .slack, .facebook, .githawk]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = "MessageInputBar"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Styles", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold) ]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Styles"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = styles[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ExampleViewController(messageInputBarStyle: styles[indexPath.row]), animated: true)
//        splitViewController?.showDetailViewController(ExampleViewController(), sender: self)
    }
    
}
