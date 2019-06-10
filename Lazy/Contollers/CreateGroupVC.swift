

//
//  CreateGroupVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/23/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase
class CreateGroupVC: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    @IBOutlet weak var membersView: RoundView!
    @IBOutlet weak var memberLbl: UITextField!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UITextField!
    @IBOutlet weak var groupDescriptionLbl: UITextField!
    @IBOutlet weak var informationView: RoundView!
    
    var userArray = [UserBasic]()
    var chosenUserArray = [String]()
    var userNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupNavig()
    }
    
    func setupNavig(){
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Search For Members"
        searchBar.searchBar.showsCancelButton = false
        navigationItem.searchController = searchBar
        navigationItem.title = "CREATE GROUP"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        searchBar.searchBar.delegate = self
        let rightBtn = UIBarButtonItem(image:UIImage(named: "arrow"), style: .done, target: self, action: #selector(doneBtnPressed(_:)))
        
        navigationItem.rightBarButtonItem = rightBtn

        
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            tableView.isHidden = true
            userArray = []
            tableView.reloadData()
            if userArray.isEmpty{
                informationView.isHidden = false
                return
            }else{
                informationView.isHidden = true
                tableView.isHidden = true
                return
            }
        }else{
            informationView.isHidden = true
            tableView.isHidden = false
            DataServices.instanse.getNamesForSearch(userField: searchText) { (usernames, success) in
                if success{
                    self.userArray = usernames
                    self.userArray.reverse()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneBtnPressed(_ sender: Any) {
        if groupTitleLbl.text != "" && !chosenUserArray.isEmpty {
            var userIds = chosenUserArray
            userIds.append((Auth.auth().currentUser?.uid)!)
            DataServices.instanse.createGroup(title: groupTitleLbl.text!, discreption: groupDescriptionLbl.text!, members: userIds) { (success) in
                if success{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("Field to Create Group")
                }
            }
            
        }
    }
    
    
    
}

extension CreateGroupVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell") as? MemberCell else { return UITableViewCell()}
        let username = userArray[indexPath.row]
        
        
        
        if chosenUserArray.contains(username.uid){
            ImageServices.instance.loadImage(imageView: cell.profileImage , url: username.imageURL)
            cell.confiqueView(userName: username.userName, isSelected:  true)
        }else{
            ImageServices.instance.loadImage(imageView: cell.profileImage , url: username.imageURL)
            cell.confiqueView(userName: username.userName, isSelected: false)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let cell = tableView.cellForRow(at: indexPath) as? MemberCell else { return}
        
        let users = userArray[indexPath.row]

        ImageServices.instance.loadImage(imageView: cell.profileImage, url: users.imageURL)
        if !chosenUserArray.contains(users.uid) {
            chosenUserArray.append(users.uid)
            userNames.append(users.userName)
            memberViewHeight.constant = 20
            memberLbl.text = userNames.joined(separator: ", ")
        }else{
            chosenUserArray = chosenUserArray.filter({ $0 != users.uid })
            userNames = userNames.filter({ $0 != users.userName })
        }
        if userNames.count >= 1 {
                memberViewHeight.constant = 20
                memberLbl.text = userNames.joined(separator: ", ")
        }else{
            memberViewHeight.constant = 0
            userNames  = []
        }
        
        print(chosenUserArray)
    }
    
    
    
}
