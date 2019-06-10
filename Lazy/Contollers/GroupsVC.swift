//
//  SecondViewController.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/6/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var groupsArray = [GroupModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = false
        setupNavig()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "GROUPS"
        DataServices.instanse.getGroups {[weak self] (returnedGroups) in
            self?.groupsArray = returnedGroups
            self?.tableView.reloadData()
        }
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        groupsArray = []
    }
    
    
    func setupNavig(){
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
        
    }
    
}





extension GroupsVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell else {return UITableViewCell()}
        
        let group = groupsArray[indexPath.row]
        cell.configueGroup(forGroupImage: UIImage(named: "doctor")!, forGroupTitle: group.title, forGroupMember: "\(group.memberCount)")
        
        return cell
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupFeedSegua"{
            let index = self.tableView.indexPathForSelectedRow
            guard let groupFeed = segue.destination as? GroupFeedVC  else {return}
            groupFeed.initData(group: groupsArray[(index?.row)!])
            
        }
    }
}

