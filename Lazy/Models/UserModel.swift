//
//  UserModel.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/10/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation

class UserModel{
    private var _userName : String?
    private var _email : String?
    private var _firstName : String?
    private var _lastName : String?
    private var _phone : String?
    private var _workAt : String?
    private var _imageURL : String?
    private var _country : String?
    private var _city : String?
    private var _birthdate : String?
    
    public var userName : String {
        return _userName!
    }
    
    public var email : String {
        return _email!
    }
    public var firstName : String {
        return _firstName!
    }
    public var lastName : String {
        return _lastName!
    }
    public var phone : String {
        return _phone!
    }
    public var workAt : String {
        return _workAt!
    }
    public var imageURL : String {
        return _imageURL!
    }
    public var country : String {
        return _country!
    }
    public var city : String {
        return _city!
    }
    public var birthdate : String {
        return _birthdate!
    }
    
 

    
    
    init(userName : String? , email : String? ,firstName : String? , lastName : String? , phone : String? , workAt : String? , imageURL : String? , country : String? , city : String? , birthdate : String?) {
        self._userName = userName
        self._email = email
        self._firstName = firstName
        self._lastName = lastName
        self._phone = phone
        self._workAt = workAt
        self._imageURL = imageURL
        self._country = country
        self._city = city
        self._birthdate = birthdate
    }
    
  
    
    deinit {
        print(" user deleted")
    }
}
