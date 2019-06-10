//
//  CommentVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/19/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase

class CommentVC: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var commentTxtField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var feedKey : String!
    var groupKey : String?
    var commentsArray = [FeedModel]()
    
    
    
    func initData(feedKey : String , groupKey : String?){
        self.feedKey = feedKey
        self.groupKey = groupKey
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "COMMENTS"
        navigationController?.navigationBar.barTintColor = UIColor.white
  
        
        DataServices.instanse.showComments(feedKey: feedKey, groupKey: groupKey) { (returnedComment) in
            self.commentsArray = returnedComment
            self.commentsArray.reverse()
            
            self.tableView.reloadData()
            
            
            if self.commentsArray.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: self.commentsArray.count - 1 , section: 0), at: .none, animated: true)
                self.tableView.reloadData()
            }
        }
 
    }
 
    

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func sendBtnPressed(_ sender: Any) {
        DataServices.instanse.addComment(feedKey: self.feedKey, groupKey: groupKey, uid: (Auth.auth().currentUser?.uid)!, content: self.commentTxtField.text!) { (success) in
                if success {
                    DataServices.instanse.showComments(feedKey: self.feedKey, groupKey: self.groupKey) { (returnedComment) in
                        self.commentsArray = returnedComment
                        
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        
                            if self.commentsArray.count > 0 {
                                self.tableView.scrollToRow(at: IndexPath(row: self.commentsArray.count - 1 , section: 0), at: .none, animated: true)
                                self.tableView.reloadData()
                            }

                            self.commentTxtField.text = ""
                            print("Comment added Done")
                        }

                    }
                  
                    
                }
                
            }
            
        }
}



extension CommentVC : UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 10, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 2
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell else {return UITableViewCell()}
        
        DispatchQueue.global(qos : .background).async {
            let comment = self.commentsArray[indexPath.row]
            DataServices.instanse.getDataForFeed(senderID:comment.senderID ) { ( userInformation ,success) in
                if success{
                    DispatchQueue.main.async {
                        cell.commentModel = comment
                        cell.userModel = userInformation
                    }
                    ImageServices.instance.loadImage(imageView: cell.profileImage, url: userInformation.imageURL)
                }
            }
        }
        
        

        
        
        return cell
    }

    
    
    
}



