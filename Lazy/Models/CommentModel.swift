//
//  CommentModel.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/12/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation


class CommentModel {
    private var _senderID : String
    private var _content : String

    
    
    public var senderID : String {
        return _senderID
    }
    
    public var content : String {
        return _content
    }
    
    init(senderID : String , content : String) {
        self._senderID = senderID
        self._content = content
    }
}
