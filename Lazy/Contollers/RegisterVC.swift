//
//  LogoutVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/8/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterVC: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var signUpBtn: ShadowButton!
    @IBOutlet weak var userNameLbl: InsertTextField!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameImageVIew: UIImageView!
    
    @IBOutlet weak var emailLbl: InsertTextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailimageView: UIImageView!
    
    
    @IBOutlet weak var passwordLbl: InsertTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordImageView: UIImageView!
    
    
    @IBOutlet weak var comfirmPasswordLbl: InsertTextField!
    @IBOutlet weak var comfirmPasswordView: UIView!
    @IBOutlet weak var comfirmPasswordImageView: UIImageView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLbl.delegate = self
        emailLbl.delegate = self
        passwordLbl.delegate = self
        comfirmPasswordLbl.delegate = self
        
        userNameLbl.leftViewMode = .always
        emailLbl.leftViewMode = .always
        passwordLbl.leftViewMode = .always
        comfirmPasswordLbl.leftViewMode = .always
        userNameLbl.leftView = UIImageView(image: UIImage(named: "user-icon"))
        emailLbl.leftView = UIImageView(image: UIImage(named: "email-icon"))
        passwordLbl.leftView = UIImageView(image: UIImage(named: "password-icon"))
        comfirmPasswordLbl.leftView = UIImageView(image: UIImage(named: "password-icon"))
        
        
        
        
        userNameLbl.addTarget(self, action: #selector(userNameCheck), for: .editingDidEnd)
        emailLbl.addTarget(self, action: #selector(emailCheck), for: .editingDidEnd)
        passwordLbl.addTarget(self, action: #selector(passwordCheck), for: .editingDidEnd)
        comfirmPasswordLbl.addTarget(self, action: #selector(comfirmPasswordCheck), for: .editingDidEnd)
        
        
        
        
    }
    
    @objc func userNameCheck(){
        if userNameLbl.text?.isEmpty == false{
            userNameImageVIew.image = UIImage(named: "done-icon")
            userNameView.backgroundColor = #colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1)
        }else{
            userNameImageVIew.image = nil
            userNameView.backgroundColor = #colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1)
        }
    }
    
    @objc func emailCheck(){
        if emailLbl.text?.isEmpty == false{
            emailimageView.image = UIImage(named: "done-icon")
            emailView.backgroundColor = #colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1)
        }else{
            emailimageView.image = nil
            emailView.backgroundColor = #colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1)
        }
    }

    @objc func passwordCheck(){
        if passwordLbl.text?.isEmpty == false{
            if (passwordLbl.text?.count)! >= 6 {
                passwordImageView.image = UIImage(named: "done-icon")
                passwordView.backgroundColor = #colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1)
            }else{
                passwordImageView.image = UIImage(named: "error-icon")
                passwordView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.0431372549, blue: 0.1568627451, alpha: 1)
            }
        }else{
            passwordImageView.image = nil
            passwordView.backgroundColor = #colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1)
        }
        
    }
    
    @objc func comfirmPasswordCheck(){
        if comfirmPasswordLbl.text?.isEmpty == false{
            if  comfirmPasswordLbl.text != passwordLbl.text {
                comfirmPasswordImageView.image = UIImage(named: "error-icon")
                comfirmPasswordView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.0431372549, blue: 0.1568627451, alpha: 1)
            }else{
                comfirmPasswordImageView.image = UIImage(named: "done-icon")
                comfirmPasswordView.backgroundColor = #colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1)
                }
        
        }else{
            comfirmPasswordImageView.image = nil
            comfirmPasswordView.backgroundColor = #colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1)
        }
    }
    
    

   
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        if checkInPut(textField: userNameLbl, viewField: userNameView, imageField: userNameImageVIew) &&
           checkInPut(textField: emailLbl, viewField: emailView, imageField: emailimageView) &&
            checkInPut(textField: passwordLbl, viewField: passwordView, imageField: passwordImageView) &&
            checkInPut(textField: comfirmPasswordLbl, viewField: comfirmPasswordView, imageField: comfirmPasswordImageView){
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.show(withStatus: "REGISTER")
            
            AuthServices.instance.registerUser(forUserName: userNameLbl.text!, forEmail: emailLbl.text!, forPassword: passwordLbl.text!, forComfirmPW: comfirmPasswordLbl.text!) { (success) in
                if success {
                    SVProgressHUD.dismiss(completion: {
                        print("Sign Up Done")
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    
    }
    
    
    
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


