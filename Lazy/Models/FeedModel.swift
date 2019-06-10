//
//  FeedModel.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/12/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation

class FeedModel{
    private var _senderID : String
    private var _content : String
    private var _key : String?

    
    public var senderID : String {
        return _senderID
    }
    
    public var content : String {
        return _content
    }
    
    public var key : String{
        return _key!
    }
    
  
    
    init(senderID : String , content : String , key : String) {
        self._senderID = senderID
        self._content = content
        self._key = key
       
    }
    
    deinit {
        print("print feed deleted")
    }
}
