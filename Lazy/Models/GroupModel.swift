//
//  GroupModel.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/25/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation


class GroupModel{
    private var _title : String
    private var _members : [String]
    private var _memberCount : Int
    private var _groupKey : String
    private var _discreption : String
    
    
    public var title :String {
        return _title
    }
    
 
    public var member :[String] {
        return _members
    }
    public var memberCount :Int {
        return _memberCount
    }
    public var groupKey :String {
        return _groupKey
    }
    public var discreption :String {
        return _discreption
    }
    
    init(title : String , members : [String] ,discreption : String, memberCount : Int , groupKey : String) {
        self._title = title
        self._members = members
        self._memberCount = memberCount
        self._groupKey = groupKey
        self._discreption = discreption
    }
    
}
