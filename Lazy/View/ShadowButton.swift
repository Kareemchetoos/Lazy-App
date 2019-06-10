//
//  ShadowButton.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/7/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class ShadowButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 7
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
    }

}
