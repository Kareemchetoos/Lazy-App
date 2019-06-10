//
//  CommentView.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/19/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class CommentView: UILabel {

    override func awakeFromNib() {
        layer.cornerRadius = 7
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 0.968627451, alpha: 1)

    }
}
