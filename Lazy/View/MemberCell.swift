//
//  MemberCell.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/23/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var profileImage: RoundImageView!
    
    @IBOutlet weak var addToGroup: UIButton!
    
    var choose = false
    
    
    
    
    func confiqueView(userName :String , isSelected : Bool){
        self.userNameLbl.text = userName
        if isSelected{
            self.addToGroup.isHidden = false
        }else{
           self.addToGroup.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            if choose == false{
                addToGroup.isHidden = false
                choose = true
                
            }else{
                addToGroup.isHidden = true
                choose = false
            }
        }
    }
}
