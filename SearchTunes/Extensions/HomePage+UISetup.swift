//
//  HomePage+UISetup.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 15.06.2023.
//

import Foundation
import UIKit

extension HomeViewController {
    
    func setupUI() {
        setupSearchBar()
        setGradient()
        setupNavController()
    }
    
    func setupNavController() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = UIColor.green
        UINavigationBar.appearance().tintColor = UIColor.green
    }
    
    func setupEmptyView() {
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.text = "No items to display"
        tableView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: HomePageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: HomePageTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for a track"
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .black
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = searchTextField.leftView {
                searchTextField.leftViewMode = .always
                searchTextField.autocorrectionType = .no
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: leftView.frame.height)) // Adjust padding width here
                searchTextField.leftView = paddingView
                searchTextField.backgroundColor = .white
                paddingView.addSubview(leftView)
            }
        }
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.layer.shadowRadius = 4
        searchBar.layer.shadowOpacity = 0.3
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
            textField.autocorrectionType = .no
        }
    }
}
