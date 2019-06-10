//
//  GroupFeedVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 3/1/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
     var profileImage: RoundImageView!
    
    var index : IndexPath?
    var myGroup :GroupModel!
    func initData(group : GroupModel){
        self.myGroup = group
    }
    
    var feedArray = [FeedModel]()
    var starsArray = [StarsModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = myGroup.title
        profileImage = RoundImageView()
        
        DataServices.instanse.getFeeds(groupKey: myGroup.groupKey) { (returnFeeds) in
            self.feedArray = returnFeeds
            self.tableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataServices.instanse.getProfileImageUrl(uid: (Auth.auth().currentUser?.uid)!) { (success, userData) in
            if success{
                ImageServices.instance.loadImage(imageView: self.profileImage, url: userData.imageURL)
            }
        }
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    

    
}



extension GroupFeedVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell else {return UITableViewCell()}
        let feed = feedArray[indexPath.row]
        
        cell.delegate = self
        cell.feedModel = feed
        
        DataServices.instanse.getDataForFeed(senderID: (Auth.auth().currentUser?.uid)!) { (userData, success) in
            if success{
                cell.userModel = userData
                ImageServices.instance.loadImage(imageView: cell.profileImageView, url: userData.imageURL)
            }
        }
            DataServices.instanse.updatStars(feedKey: feed.key, groupKey: myGroup.groupKey,  cell: cell)
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createGroupFeedSegua"{
            guard let createFeed = segue.destination as? CreateFeedVC else {return}
            createFeed.initData(image: profileImage.image)
            createFeed.initFeed(groupKey: myGroup.groupKey)
        }
        if segue.identifier == "commentGroupSegua"{
            guard let commentVC = segue.destination as? CommentVC else {return}

            let feed = feedArray[(index?.row)!]
            commentVC.initData(feedKey: feed.key, groupKey: myGroup.groupKey)
            
        }
    }
    
    
}

var feeds : FeedModel?
extension GroupFeedVC : feedCellDelegate {
    func modifyComment(cell: FeedCell) {
            index = tableView.indexPath(for: cell)
    }
    
    
    func modifyStar(cell: FeedCell) {
        let indexPath = tableView.indexPath(for: cell)
        feeds = feedArray[(indexPath?.row)!]
        let userUID = Auth.auth().currentUser?.uid
        
        
        DispatchQueue.global().async {
            DataServices.instanse.checkForStar(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey) { (success) in
                if success{
                    DataServices.instanse.getStarValue(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey, uid: userUID!) { (returnStars) in
                        if returnStars.isEmpty{
                            DataServices.instanse.addStar(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey, userID: userUID!, handler: { (success) in
                                print("add New Star Done")
                                DispatchQueue.main.async {
                                    DataServices.instanse.updatStars(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey,   cell: cell)
                                }
                            })
                        }else{
                            let starKey = returnStars[0].starKey
                            DataServices.instanse.removeStar(feedKey: feeds!.key, groupKey: self.myGroup.groupKey, starKey: starKey, handler: { (success) in
                                print("remove Star Done")
                                DispatchQueue.main.async {
                                    DataServices.instanse.updatStars(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey,  cell: cell)
                                    cell.confiqeStarBtn(image: "star_gray")
                                }
                                
                            })
                        }
                    }
                }else{
                    DataServices.instanse.addStar(feedKey: feeds!.key, groupKey: self.myGroup.groupKey, userID: userUID!, handler: { (success) in
                        DispatchQueue.main.async {
                            print("add New Star Done")
                            DataServices.instanse.updatStars(feedKey: (feeds?.key)!, groupKey: self.myGroup.groupKey, cell: cell)                        }
                        
                    })
                }
            }
            
        }
        
        
        
        
        
    }
}
