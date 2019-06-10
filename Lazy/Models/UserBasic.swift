//
//  File.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/23/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation
class UserBasic{
    private var _userName : String
    private var _uid : String
    private var _imageURL : String
    
    
    public var userName : String {
        return _userName
    }
    
    public var uid : String {
        return _uid
    }
    
    public var imageURL : String {
        return _imageURL
    }

    init(userName : String, uid : String , imageURL : String) {
        self._userName = userName
        self._uid = uid
        self._imageURL = imageURL
    }
}
