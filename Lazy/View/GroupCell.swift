//
//  GroupCell.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/7/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var groupImageView: RoundImageView!
    
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupMembersLbl: UILabel!
    
    
    
    func configueGroup(forGroupImage image : UIImage , forGroupTitle title : String , forGroupMember member : String){
        self.groupImageView.image = image
        self.groupTitleLbl.text = title
        self.groupMembersLbl.text = member
        
    }
}
