//
//  CommenCell.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/19/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
  

    var commentModel : FeedModel? {
        didSet{
            self.confiqueView()
        }
    }
    var userModel : UserModel? {
        didSet{
            self.confiqueView()
        }
    }

    
    func confiqueView(){
        self.userNameLbl.text = userModel?.userName
        self.commentLbl.text = commentModel?.content
    }

}
