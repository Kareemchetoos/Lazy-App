//
//  StarsModel.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/12/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation

class StarsModel{
    private var _senderID : String
    private var _starKey : String
  


    
    
    public var senderID : String {
        return _senderID
    }
    public var starKey : String{
        return _starKey
    }
 
    
    init(senderID : String , starKey : String) {
        self._senderID = senderID
        self._starKey = starKey
    
    }
    
    deinit {
        print("star deleted")
    }
}
