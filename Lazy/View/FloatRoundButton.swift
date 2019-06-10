//
//  RoundButton.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/7/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class FloatRoundButton: UIButton {

    override func awakeFromNib() {
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height/2
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero

    }

}
