//
//  ProfileVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/6/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class ProfileVC: UIViewController {

    
    var userData : UserModel?
    var myFeedsArray = [FeedModel]()
    var starsArray = [StarsModel]()
    
    var index : IndexPath?
    
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var workAtLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var birthdateLbl: UILabel!
    @IBOutlet weak var groupCountLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
        setupNavig()
        
    
    }
    func setupNavig(){
        navigationItem.title = "PROFILE"
        let buttonImage = UIImage(named: "logout-icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(logoutBtnPressed(_:)))
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
        SVProgressHUD.setDefaultStyle(.custom)

        DispatchQueue.global(qos : .background).async {
            if Auth.auth().currentUser != nil{
                DataServices.instanse.getUserData(uid: (Auth.auth().currentUser?.uid)!) {[weak self] (success, myData) in
                    SVProgressHUD.show()
                    if success{
                        self?.userData = myData
                        ImageServices.instance.loadImage(imageView: self!.profileImage, url: self!.userData!.imageURL)
                        DispatchQueue.main.async {
                            self?.userNameLbl.text = self?.userData!.userName
                            self?.workAtLbl.text = "Work at " + (self?.userData!.workAt)!
                            self?.locationLbl.text = self!.userData!.country + " , " + self!.userData!.city
                            self?.birthdateLbl.text = "Born " + self!.userData!.birthdate
                        }
                        
                        SVProgressHUD.dismiss()
                        
                    }else{
                        print("Error loadding Data")
                    }
                }
                
                
                DataServices.instanse.getFeeds(groupKey: nil) {(allFeeds) in
                    for feed in allFeeds{
                        if feed.senderID == Auth.auth().currentUser?.uid{
                            self.myFeedsArray.append(feed)
                        }
                    }
                    
                        self.myFeedsArray.reverse()
                        self.tableView.reloadData()
                }
                
                DataServices.instanse.getGroups(handler: { (allGroups) in
                    DataServices.instanse.myGroups(groups: allGroups, handler: { (returnGroupsCount) in
                        self.groupCountLbl.text = "\(returnGroupsCount.count)"
                    })
                })
                
            }

        }
      
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myFeedsArray = []
        starsArray = []
    }
    


    
 

    
    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "editProfileSegua", sender: sender)
    }
    
    @objc func logoutBtnPressed(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
        SVProgressHUD.setDefaultStyle(.custom)
        
        let popUp = UIAlertController(title: "Are you Want Logout?", message: "Are you sure ?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            do{
                SVProgressHUD.show(withStatus: "LOGOUT")
                print("sign OUT DONE")
                try? Auth.auth().signOut()
                if let storyboard = self.storyboard{
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                    self.present(loginVC!, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                }
            }
        }
        popUp.addAction(cancelAction)
        popUp.addAction(logoutAction)
        present(popUp, animated: true, completion: nil)
        }

}




extension ProfileVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeedsArray.count
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
        
        let feed = myFeedsArray[indexPath.row]

        cell.delegate = self
        cell.feedModel = feed
        
        DataServices.instanse.getDataForFeed(senderID: (Auth.auth().currentUser?.uid)!) { (data, success) in
            if success{
                cell.userModel = data
                ImageServices.instance.loadImage(imageView: cell.profileImageView, url: data.imageURL)
            }
        }
        
      

            DataServices.instanse.updatStars(feedKey: feed.key, groupKey: nil,cell: cell)
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentProfileSegua"{
            guard let commentVC = segue.destination as? CommentVC else {return}
            let feed = myFeedsArray[(index?.row)!]
            commentVC.initData(feedKey: feed.key, groupKey: nil)
        }
       
    }
    
    
}


extension ProfileVC : feedCellDelegate {
    func modifyComment(cell: FeedCell) {
            index = tableView.indexPath(for: cell)
    }
    
    
    func modifyStar(cell: FeedCell) {
        let indexPath = tableView.indexPath(for: cell)
        let feed = myFeedsArray[(indexPath?.row)!]
        let userUID = Auth.auth().currentUser?.uid
        
        
        DispatchQueue.global().async {
            DataServices.instanse.checkForStar(feedKey: feed.key, groupKey: nil) { (success) in
                if success{
                    DataServices.instanse.getStarValue(feedKey: feed.key, groupKey: nil, uid: userUID!) { (returnStars) in
                        if returnStars.isEmpty{
                            DataServices.instanse.addStar(feedKey: feed.key, groupKey: nil, userID: userUID!, handler: { (success) in
                                print("add New Star Done")
                                DispatchQueue.main.async {
                                    DataServices.instanse.updatStars(feedKey: feed.key, groupKey: nil, cell: cell)
                                }
                            })
                        }else{
                            let starKey = returnStars[0].starKey
                            DataServices.instanse.removeStar(feedKey: feed.key, groupKey: nil, starKey: starKey, handler: { (success) in
                                print("remove Star Done")
                                DispatchQueue.main.async {
                                    DataServices.instanse.updatStars(feedKey: feed.key, groupKey: nil,  cell: cell)
                                    cell.confiqeStarBtn(image: "star_gray")
                                }
                                
                            })
                        }
                    }
                }else{
                    DataServices.instanse.addStar(feedKey: feed.key, groupKey: nil, userID: userUID!, handler: { (success) in
                        DispatchQueue.main.async {
                            print("add New Star Done")
                            DataServices.instanse.updatStars(feedKey: feed.key, groupKey: nil,  cell: cell)
                        }
                        
                    })
                }
            }
            
        }
        
        
        
        
        
    }
    
    
}
