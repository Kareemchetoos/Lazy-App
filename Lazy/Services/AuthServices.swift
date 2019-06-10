//
//  AuthServices.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/9/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase

class AuthServices {
    static var instance = AuthServices()
    
    
    //REGISTER USER IN FIREBASE
    func registerUser(forUserName userName : String , forEmail email : String , forPassword password : String , forComfirmPW comfirmPw : String, handler complete : @escaping(_ finish : Bool)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error1) in
            if error1 == nil {
                DataServices.instanse.createUserData(forUID: (Auth.auth().currentUser?.uid)!, userData: ["userName" : userName , "email" : email , "firstName" : "" , "lastName" : "", "phone" : ""  ,  "work" : "" , "imageURL" : "" , "born" : "" , "country" : "" , "city" : "" ], handler: { (sucess) in
                    if sucess{
                        complete(true)
                    }else{
                        print("Register Error2")
                    }
                })

            }else{
                print("Register Error1\((error1?.localizedDescription)!)")
                complete(false )
            }
        }
    }

    //SIGN IN
    func signIn(forEmail email : String , forPassword password : String , handler complete : @escaping(_ finished : Bool)->()){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                complete(true)
            }else{
                complete(false)
            }
        }
    }
    
    
    
    
    
    
}
