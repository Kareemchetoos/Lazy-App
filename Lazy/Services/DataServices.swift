//
//  DataServices.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/9/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


private let DB_BASE = Database.database().reference()
private let STORAGE_BASE = Storage.storage().reference()

    final class DataServices {
    static  let instanse = DataServices()
    private var _REF_BASE = DB_BASE
    private var _REF_STORAGE = STORAGE_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_IMAGES = STORAGE_BASE.child("profileImages/")
    private var _REF_FEEDS = DB_BASE.child("feeds")
    private var _REF_GROUPS = DB_BASE.child("groups")
    
    
    
    
    
    
    var REF_BASE : DatabaseReference {
        return _REF_BASE
    }
    
    var REF_STORAGE : StorageReference {
        return _REF_STORAGE
    }
    
    var REF_USER : DatabaseReference {
        return _REF_USERS
    }
    var REF_IMAGE : StorageReference {
        return _REF_IMAGES
    }
    
    var REF_GROUP : DatabaseReference{
        return _REF_GROUPS
    }
    
    var REF_FEED : DatabaseReference {
        return _REF_FEEDS
    }
    
    
    
    
    func createUserData(forUID uID : String,userData data : Dictionary<String , Any>, handler complete : @escaping(_ finish : Bool)->()){
        REF_USER.child(uID).updateChildValues(data)
        complete(true )
    }
    
    func profileData(uid : String , data : Dictionary<String , Any> , complete : @escaping(_ finished : Bool)->()){
        REF_USER.child(uid).updateChildValues(data)
        complete(true)
    }
    func getUserData(uid : String , handler : @escaping(_ finished : Bool , _ userData : UserModel)->() ){
        DispatchQueue.global(qos: .background).async {
            self.REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
                guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for user in userSnapShot{
                    if user.key == uid{
                        let userName = user.childSnapshot(forPath: "userName").value as! String
                        let email = user.childSnapshot(forPath: "email").value as! String
                        let firstName = user.childSnapshot(forPath: "firstName").value as! String
                        let lastName = user.childSnapshot(forPath: "lastName").value as! String
                        let phone = user.childSnapshot(forPath: "phone").value as! String
                        let workAt = user.childSnapshot(forPath: "work").value as! String
                        let imageURL = user.childSnapshot(forPath: "imageURL").value as! String
                        let country = user.childSnapshot(forPath: "country").value as! String
                        let city = user.childSnapshot(forPath: "city").value as! String
                        let birthdate = user.childSnapshot(forPath: "born").value as! String
                        
                        let myData = UserModel(userName: userName, email: email, firstName: firstName, lastName: lastName, phone: phone, workAt: workAt, imageURL: imageURL, country: country, city: city, birthdate: birthdate)
                        handler(true, myData)
                    }
                }
            }
            
        }
    }
    
    func getProfileImageUrl(uid : String , handler : @escaping(_ finished : Bool , _ profileURL : UserModel)->() ){
        
        self.REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot{
                if user.key == uid{
                    let imageURL = user.childSnapshot(forPath: "imageURL").value as! String
                    
                    let myData = UserModel(userName: nil, email: nil, firstName: nil, lastName: nil, phone: nil, workAt: nil, imageURL: imageURL, country: nil, city: nil, birthdate: nil)
                    handler(true, myData)
                }
            }
        }
        
    }
    
    
    //UPLOAD IMAGES
    func uploadProfileImage(image : UIImage , handler : @escaping(_ url : String? )->()){
        let imageName = NSUUID().uuidString
        let profileImage = self.REF_IMAGE.child(imageName)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        guard let uploadImage = image.pngData() else {return}
        profileImage.putData(uploadImage, metadata: metaData) { (metaData, error) in
            if error == nil {
                profileImage.downloadURL(completion: { (url, error) in
                    if error == nil{
                        handler(url?.absoluteString)
                    }else{
                        handler(error?.localizedDescription )
                    }
                })
            }
        }
    }
    
    func getImage(uid : String , handler : @escaping(_ finish : Bool ,_ imageUrl : String )->()){
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else{return}
            for user in userSnapShot{
                if user.key == uid{
                    let imageURl = user.childSnapshot(forPath: "imageURL").value as! String
                    handler(true, imageURl)
                }
            }
        }
    }
    ///////////////////////////////////////////////////////////////
    //FEEDS
    
    //CreateFeed
    func CreateFeed(senderID : String ,groupKey : String?, content : String  , handler : @escaping(_ finished : Bool)->() ){
        if groupKey == nil{
            REF_FEED.childByAutoId().updateChildValues(["senderID" : senderID ,"content" : content])
            handler(true)
        }else{
            REF_GROUP.child(groupKey!).child("feeds").childByAutoId().updateChildValues(["senderID" : senderID ,"content" : content])
            handler(true)
        }
    }
    
    //GET FEED
    func getFeeds(groupKey : String? ,handler :@escaping (_ feeds:[FeedModel])->()){
        var feedArray = [FeedModel]()
        if groupKey == nil{
            REF_FEED.observeSingleEvent(of: .value) { (feedSnapShot) in
                guard let feedSnapShot = feedSnapShot.children.allObjects as? [DataSnapshot] else{return}
                for feed in feedSnapShot{
                    let senderID = feed.childSnapshot(forPath: "senderID").value as! String
                    let contents = feed.childSnapshot(forPath: "content").value as! String
                    let feed = FeedModel(senderID: senderID, content: contents, key: feed.key)
                    
                    feedArray.append(feed)
                }
                handler(feedArray)
            }
        }else{
            REF_GROUP.child(groupKey!).child("feeds").observeSingleEvent(of: .value) { (dataSnapShot) in
                guard let dataSnapShot = dataSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for data in dataSnapShot{
                    let senderID = data.childSnapshot(forPath: "senderID").value as! String
                    let contents = data.childSnapshot(forPath: "content").value as! String
                    let feed = FeedModel(senderID: senderID, content: contents, key: data.key)
                    feedArray.append(feed)
                }
                handler(feedArray)
            }
        }
    }
    //GET USER DATA FOR FEED
    func getDataForFeed(senderID : String ,handler : @escaping (_ user : UserModel,_ statue : Bool)->()){
        self.REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot{
                if user.key == senderID{
                    let userName = user.childSnapshot(forPath: "userName").value as! String
                    let workAt = user.childSnapshot(forPath: "work").value as! String
                    let imageURL = user.childSnapshot(forPath: "imageURL").value as! String
                    let user = UserModel(userName: userName, email: nil, firstName: nil, lastName: nil, phone: nil, workAt: workAt, imageURL: imageURL, country: nil, city: nil, birthdate: nil)
                    handler(user , true)
                }
            }
        }
    }
    /////////////////////////////////////////////////////////////////
    
    //Edit FEEDs
    func addStar(feedKey : String , groupKey : String? ,userID : String, handler : @escaping(_ finished : Bool)->()){
        if groupKey == nil{
            REF_FEED.child(feedKey).child("stars").childByAutoId().updateChildValues(["senderID" : userID])
            handler(true)
        }else{
            REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("stars").childByAutoId().updateChildValues(["senderID" : userID])
            handler(true)
        }
        
    }
    
    //ADD Comment
    func addComment(feedKey :String ,groupKey : String? ,uid : String , content : String ,  handler : @escaping(_ finished : Bool)->()){
        if groupKey == nil{
            REF_FEED.child(feedKey).child("comments").childByAutoId().updateChildValues(["senderID" : uid , "content" : content])
            handler(true)
        }else{
            REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("comments").childByAutoId().updateChildValues(["senderID" : uid , "content" : content])
            handler(true)
        }
      
    }
    
    //Show Comment
    func showComments(feedKey :String,groupKey : String? , handler : @escaping(_ comments : [FeedModel])->()){
        var myComments = [FeedModel]()
        if groupKey == nil{
            REF_FEED.child(feedKey).child("comments").observeSingleEvent(of: .value) { (commentSnapShot) in
                guard let commentSnapShot = commentSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for comment in commentSnapShot{
                    let content = comment.childSnapshot(forPath: "content").value as! String
                    let senderID = comment.childSnapshot(forPath: "senderID").value as! String
                    
                    let feedComment = FeedModel(senderID: senderID, content: content, key: comment.key)
                    myComments.append(feedComment)
                }
                handler(myComments)
            }
        }else{
            REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("comments").observeSingleEvent(of: .value) { (commentSnapShot) in
                guard let commentSnapShot = commentSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for comment in commentSnapShot{
                    let content = comment.childSnapshot(forPath: "content").value as! String
                    let senderID = comment.childSnapshot(forPath: "senderID").value as! String
                    
                    let feedComment = FeedModel(senderID: senderID, content: content, key: comment.key)
                    myComments.append(feedComment)
                }
                handler(myComments)
            }

        }
        
    }
    
    //check if star exist
    func checkForStar(feedKey : String, groupKey : String? , handler : @escaping(_ finished : Bool)->()){
        if groupKey == nil{
            REF_FEED.child(feedKey).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild("stars"){
                    handler(true)
                }else{
                    handler(false)
                }
            }
        }else{
            REF_GROUP.child(groupKey!).child("feeds").child(feedKey).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild("stars"){
                    handler(true)
                }else{
                    handler(false)
                }
            }
        }
     
    }
    
    
    //get Stars of feed
    func getStarValue(feedKey : String, groupKey : String?,uid : String,handler : @escaping(_ starArray: [StarsModel])->()){
        var stars = [StarsModel]()
        if groupKey == nil{
            REF_FEED.child(feedKey).child("stars").observeSingleEvent(of: .value) { (userSnapShot) in
                guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for user in userSnapShot{
                    let senderID = user.childSnapshot(forPath: "senderID").value as! String
                    if senderID == uid{
                        let myStar = StarsModel(senderID: senderID, starKey: user.key)
                        stars.append(myStar)
                    }
                }
                handler(stars)
            }
        }else{
            REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("stars").observeSingleEvent(of: .value) { (userSnapShot) in
                guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for user in userSnapShot{
                    let senderID = user.childSnapshot(forPath: "senderID").value as! String
                    if senderID == uid{
                        let myStar = StarsModel(senderID: senderID, starKey: user.key)
                        stars.append(myStar)
                    }
                }
                handler(stars)
            }
        }

    }
    
    //remove Stars
    func removeStar(feedKey: String,groupKey : String? , starKey : String ,handler : @escaping(_ finished : Bool)->()){
        if groupKey == nil{
            REF_FEED.child(feedKey).child("stars").child(starKey).removeValue()
            handler(true)
        }else{
        REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("stars").child(starKey).removeValue()
            handler(true)
        }
       
    }
    
    
    func starsCount(feedKey : String, groupKey :String?,handler : @escaping(_ stars : [StarsModel])->()){
        var starArray = [StarsModel]()
        if groupKey == nil{
            REF_FEED.child(feedKey).child("stars").observeSingleEvent(of: .value) { (userSnapShot) in
                guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for data in userSnapShot{
                    let senderID = data.childSnapshot(forPath: "senderID").value as! String
                    let star = StarsModel(senderID: senderID, starKey: data.key)
                    starArray.append(star)
                }
                handler(starArray)
            }
        }else{
    REF_GROUP.child(groupKey!).child("feeds").child(feedKey).child("stars").observeSingleEvent(of: .value) { (userSnapShot) in
                guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
                for data in userSnapShot{
                    let senderID = data.childSnapshot(forPath: "senderID").value as! String
                    let star = StarsModel(senderID: senderID, starKey: data.key)
                    starArray.append(star)
                }
                handler(starArray)
            }
            
        }
    }
    
    
    //update stars
    func updatStars(feedKey : String,groupKey : String? , cell : FeedCell){
        var starsArray = [StarsModel]()
        DataServices.instanse.starsCount(feedKey: feedKey, groupKey: groupKey, handler: {(returnedStars) in
            starsArray = returnedStars
            cell.confiqueStarCount(stars:"\((starsArray.count))" )
            if starsArray.count == 0{
                cell.confiqeStarBtn(image: "star_gray")
            }else{
                for star in starsArray{
                    if star.senderID == Auth.auth().currentUser?.uid{
                        DispatchQueue.main.async {
                            cell.confiqeStarBtn(image: "star_orange")
                        }
                    }else{
                        DispatchQueue.main.async {
                            cell.confiqeStarBtn(image: "star_gray")
                        }
                    }
                }
            }
            
            
        })
    }
    
    
    
    
  /////////////////////////////////////////////////////////////////
    
    //GROUPS FUNCTION
    func createGroup(title : String ,discreption : String , members : [String] , handler : @escaping(_ finished : Bool)->()){
        REF_GROUP.childByAutoId().updateChildValues(["title" : title,"discreption" : discreption  , "members" : members] )
        handler(true)
        
    }
    
    //get All groups
    func getGroups(handler : @escaping(_ groupData : [GroupModel])->()){
        var groupsArray = [GroupModel]()
        REF_GROUP.observeSingleEvent(of: .value) { (groupSnapShot) in
            guard let groupSnapShot = groupSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for group in groupSnapShot{
                let members = group.childSnapshot(forPath: "members").value as! [String]
                if members.contains((Auth.auth().currentUser?.uid)!){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let groupKey = group.key
                    let discreption = group.childSnapshot(forPath: "discreption").value as! String
                    
                    let groupValue = GroupModel(title: title, members: members, discreption: discreption, memberCount: members.count, groupKey: groupKey)
                    groupsArray.append(groupValue)
                }
            }
            print(groupsArray.count)
            handler(groupsArray)
        }
    }
    
    func myGroups(groups : [GroupModel], handler : @escaping(_ count : [String])->()){
        var groupCount = [String]()
        for group in groups{
            let members = group.member
            for user in members{
                if user == Auth.auth().currentUser?.uid{
                    groupCount.append(group.groupKey)
                }
            }
        }
        handler(groupCount)
    }
    
    func getNamesForSearch(userField text : String ,completion handler : @escaping (_ usernames:[UserBasic],_ statue : Bool)->()){
        var userArray = [UserBasic]()
        REF_USER.observeSingleEvent(of: .value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot{
                let username = user.childSnapshot(forPath: "userName").value as! String
                if username.contains(text) == true && user.key != Auth.auth().currentUser?.uid   {
                    let imageURL = user.childSnapshot(forPath: "imageURL").value as! String
                    let users = UserBasic(userName: username, uid: user.key, imageURL: imageURL)
                    userArray.append(users)
                }
            }
            handler(userArray , true)
        }
    }

    
    
  //////////////////////////////////////////////////////////////
    
    
    

    
    

    
    

    
}
