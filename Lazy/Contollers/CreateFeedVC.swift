//
//  CreateFeedVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/12/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase

class CreateFeedVC: UIViewController , UITextViewDelegate {
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var feedTxtField: UITextView!
    
    var myImage : UIImage?
    
    var groupKey : String?
    
    func initFeed(groupKey : String){
        self.groupKey = groupKey
    }
    
    func initData(image : UIImage?){
        myImage = image
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = myImage
        feedTxtField.delegate = self
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "CREATE FEED"
        navigationController?.navigationBar.barTintColor = UIColor.white
        let rightBtn = UIBarButtonItem(image:UIImage(named: "arrow"), style: .done, target: self, action: #selector(doneBtnPressed(_:)))
       
        navigationItem.rightBarButtonItem = rightBtn
    }
   


    @objc func doneBtnPressed(_ sender: Any) {
        if feedTxtField.text != nil && feedTxtField.text != "What do you think?" {
            navigationItem.rightBarButtonItem?.isEnabled = false
            if groupKey == nil{
                DataServices.instanse.CreateFeed(senderID: (Auth.auth().currentUser?.uid)!, groupKey: nil, content: feedTxtField.text) { (success) in
                    if success{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                DataServices.instanse.CreateFeed(senderID: (Auth.auth().currentUser?.uid)!, groupKey: groupKey, content: feedTxtField.text) { (success) in
                    if success{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = true
            
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        feedTxtField.text = ""
        feedTxtField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}


