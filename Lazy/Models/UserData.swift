//
//  UserData.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/26/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation

class UserData{
    private var _userName : String
    private var _id : String

    public var userName : String{
        return _userName
    }
    public var id : String{
        return _id
    }
    
    init(userName : String , id : String) {
        self._userName = userName
        self._id = id
    }
}
