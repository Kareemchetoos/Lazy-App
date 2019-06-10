//
//  FirstViewController.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/6/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class FeedVC: UIViewController {
    
    
    
    var feedsArray = [FeedModel]()
    var starsArray = [StarsModel]()
    var userArray = [UserModel]()
    var index : IndexPath?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: RoundImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileImage)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
        SVProgressHUD.setDefaultStyle(.custom)
        if Auth.auth().currentUser != nil{
            SVProgressHUD.show()
            
            DataServices.instanse.getProfileImageUrl(uid: (Auth.auth().currentUser?.uid)!, handler: { (success, imageURL) in
                if success{
                    ImageServices.instance.loadImage(imageView: self.profileImage, url: imageURL.imageURL)
                }
            })
            
            
            
            DataServices.instanse.getFeeds(groupKey: nil) {[unowned self] (allFeeds) in
                if allFeeds.count != self.feedsArray.count{
                    self.feedsArray = allFeeds
                    self.feedsArray.reverse()
                    self.tableView.reloadData()
                }else{
                    return
                }
            }
            for feed in feedsArray {
                DataServices.instanse.getDataForFeed(senderID: feed.senderID) { (userData, success) in
                    if success {
                        self.userArray.append(userData)
                    }
                }
            }
            
            
            
            
            
        }else{
            return
        }
        
        
        
        SVProgressHUD.dismiss()
    }
    
    
    
}

extension FeedVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 20, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 2
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell else {return UITableViewCell()}
        
        let feed = feedsArray[indexPath.row]
        
        cell.feedModel = feed
        
        cell.delegate = self
        
        
        
        
        DataServices.instanse.getDataForFeed(senderID:feed.senderID ) { ( userInformation ,success) in
            if success{
                cell.userModel = userInformation
                ImageServices.instance.loadImage(imageView: cell.profileImageView, url: userInformation.imageURL)
            }
        }
        
        
        
        
        DispatchQueue.global().async {
            DataServices.instanse.updatStars(feedKey: feed.key, groupKey: nil, cell: cell)
        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFeedSegua"{
            guard let createFeedVC = segue.destination as? CreateFeedVC else {return}
            createFeedVC.initData(image: profileImage.image)
        }
        if segue.identifier == "commentSegua"{
            guard let commentVC = segue.destination as? CommentVC else {return}
            let feed = feedsArray[(index?.row)!]
            commentVC.initData(feedKey: feed.key, groupKey: nil)
            
        }
        
    }
    
    
    
    
}


var feed : FeedModel?
extension FeedVC : feedCellDelegate {
    func modifyComment(cell: FeedCell) {
        index = tableView.indexPath(for: cell)
    }
    
    
    
    func modifyStar(cell: FeedCell) {
        let indexPath = tableView.indexPath(for: cell)
        feed = feedsArray[(indexPath?.row)!]
        let userUID = Auth.auth().currentUser?.uid
        
        
        DispatchQueue.global().async {
            DataServices.instanse.checkForStar(feedKey: feed!.key, groupKey: nil) { (success) in
                if success{
                    DataServices.instanse.getStarValue(feedKey: feed!.key, groupKey: nil, uid: userUID!) { (returnStars) in
                        if returnStars.isEmpty{
                            DataServices.instanse.addStar(feedKey: feed!.key, groupKey: nil, userID: userUID!, handler: { (success) in
                                print("add New Star Done")
                                DispatchQueue.main.async {
                                    DataServices.instanse.updatStars(feedKey: (feed?.key)!, groupKey: nil, cell: cell)
                                }
                            })
                        }else{
                            let starKey = returnStars[0].starKey
                            DataServices.instanse.removeStar(feedKey: feed!.key, groupKey: nil, starKey: starKey, handler: { (success) in
                                print("remove Star Done")
                                DispatchQueue.main.async {
                                    
                                    DataServices.instanse.updatStars(feedKey: (feed?.key)!, groupKey: nil, cell: cell)
                                    cell.confiqeStarBtn(image: "star_gray")
                                }
                                
                            })
                        }
                    }
                }else{
                    DataServices.instanse.addStar(feedKey: feed!.key, groupKey: nil, userID: userUID!, handler: { (success) in
                        DispatchQueue.main.async {
                            print("add New Star Done")
                            DataServices.instanse.updatStars(feedKey: (feed?.key)!, groupKey: nil, cell: cell)
                        }
                    })
                }
            }
        }
    }
}
