//
//  InsertTextField.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/8/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

class InsertTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 5)

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func setupView(){
        let placeHolder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6976919416, green: 0.6976919416, blue: 0.6976919416, alpha: 1)])
        self.attributedPlaceholder = placeHolder
    }
    
    
}
