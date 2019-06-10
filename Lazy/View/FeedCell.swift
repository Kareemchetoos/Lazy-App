//
//  FeedCell.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/6/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase

protocol feedCellDelegate : AnyObject {
    func modifyStar(cell : FeedCell)
    func modifyComment(cell:FeedCell)
}


class FeedCell: UITableViewCell {

     weak var delegate : feedCellDelegate?
    
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var profileTitleLbl: UILabel!
    @IBOutlet weak var starCountLbl: UILabel!
    @IBOutlet weak var jobTitleLbl: UILabel!
    @IBOutlet weak var postLbl: UILabel!
    @IBOutlet weak var starBtn: UIButton!
    
    var userModel : UserModel?{
        didSet{
            self.confiqueFeed()
        }
    }
    var feedModel : FeedModel?{
        didSet{
            self.confiqueFeed()
        }
    }
    
    
    

    func confiqueFeed(){
        self.profileTitleLbl.text = userModel?.userName
        self.jobTitleLbl.text = userModel?.workAt
        self.postLbl.text = feedModel?.content
    }
    
    func confiqueStarCount(stars : String){
        starCountLbl.text = stars
    }
    
    func confiqeStarBtn(image : String){
        starBtn.setImage(UIImage(named: image), for: .normal)
    }
    
    
    @IBAction func starbtnPressed(_ sender: Any) {
        delegate?.modifyStar(cell: self)
    }
    
    @IBAction func commentBtnPressed(_ sender: Any) {
        delegate?.modifyComment(cell: self)
    }

    
    
}


