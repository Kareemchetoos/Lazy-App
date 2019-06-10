//
//  RegisterServices.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/9/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

    func checkInPut(textField : UITextField , viewField : UIView , imageField : UIImageView)->Bool{
        if (textField.text?.isEmpty)! {
            imageField.image = UIImage(named: "error-icon")
            viewField.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.0431372549, blue: 0.1568627451, alpha: 1)
            return false
        }else{
            return true
        }
    }

