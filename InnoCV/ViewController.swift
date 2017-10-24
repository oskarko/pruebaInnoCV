//
//  ViewController.swift
//  InnoCV
//
//  Created by Oscar Rodriguez Garrucho on 23/10/17.
//  Copyright © 2017 Main 3.0. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "userCell"
    var tapGesture : UITapGestureRecognizer!
    var allUsers: [CoreDataUser] = [CoreDataUser]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "userCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        searchText.delegate = self
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tapGesture.cancelsTouchesInView = false // translate the event touch to the next view (tableView, for example)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ECProgressView.shared.showProgressView(view)
        
        UserService.shared.getAllUsers() { response in
            
            ECProgressView.shared.hideProgressView()
            if let response = response {

                print("call to the API: \(response["status"] ?? "")")
            }
            // if we don't hace internet connection, we must use the data cache
            if let allUsers = LocalCoreDataUserService.shared.getAllUsers() {
                self.allUsers = allUsers
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func refreshData(refreshControl: UIRefreshControl) {
        
        UserService.shared.getAllUsers() { response in


            if let response = response {
                
                print("call to the API: \(response["status"] ?? "")")
            }
            // if we don't hace internet connection, we must use the data cache
            if let allUsers = LocalCoreDataUserService.shared.getAllUsers() {
                self.allUsers = allUsers
                self.tableView.reloadData()
            }
            refreshControl.endRefreshing()
        }
        
    }
    
    
    
    
    func possibleMatches(_ possibleName: String) -> [CoreDataUser]{
        
        var possibleUsers:[CoreDataUser] = [CoreDataUser]()
        
        if possibleName.isEmpty ,let users = LocalCoreDataUserService.shared.getAllUsers() {
            possibleUsers = users
        }
        else if let users = LocalCoreDataUserService.shared.getUsers(name: possibleName) {
            possibleUsers = users
        }
        
        return possibleUsers
    }


}


extension ViewController { // TableView delegate methods
    
    // MARK: TableView delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.allUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserCell
        
        cell.configCellWithOptions(user: self.allUsers[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let detailsVC = viewControllerWithStoryboardIdentifier(name: "details") as! DetailsViewController
        detailsVC.user = self.allUsers[indexPath.row]
        detailsVC.mode = "update"
        navigationController?.pushViewController(detailsVC, animated: true)

        
    }

}

extension ViewController { // SearchBox
    
    // MARK: SearchBox
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.view.addGestureRecognizer(self.tapGesture)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        allUsers.removeAll()
        allUsers = possibleMatches(searchText)
        self.tableView.reloadData()
    }
    
    
    func hideKeyboard() {
        self.searchText.resignFirstResponder()
        self.view.removeGestureRecognizer(self.tapGesture)
        
    }
    
    // We're deleting all coincidences and reloading tableView to hide itself if user doesn't touch it.
    func hideResultTableView() {
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }

}

