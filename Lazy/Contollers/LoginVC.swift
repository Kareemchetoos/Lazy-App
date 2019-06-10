//
//  LoginVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/8/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase
import  SVProgressHUD

class LoginVC: UIViewController , UITextFieldDelegate {

    @IBOutlet var signInBtn: UIView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordImageView: UIImageView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.leftViewMode = .always
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIImageView(image: UIImage(named: "email-icon"))
        passwordTextField.leftView = UIImageView(image: UIImage(named: "password-icon"))
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(emailCheck), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(passwordCheck), for: .editingDidEnd)

    }
    
    @objc func emailCheck(){
        if emailTextField.text?.isEmpty == false{
            emailImageView.image = UIImage(named: "done-icon")
            emailView.backgroundColor = #colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1)
        }else{
            emailImageView.image = nil
            emailView.backgroundColor = #colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1)
        }
    }
    
    @objc func passwordCheck(){
        if passwordTextField.text?.isEmpty == false{
            if (passwordTextField.text?.count)! >= 6 {
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
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if checkInPut(textField: emailTextField, viewField: emailView, imageField: emailImageView) &&
            checkInPut(textField: passwordTextField, viewField: passwordView, imageField: passwordImageView){
            
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
            SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.show(withStatus: "LOGIN")
            
            AuthServices.instance.signIn(forEmail: emailTextField.text!, forPassword: passwordTextField.text!) {[weak self] (success) in
                if success{
                    SVProgressHUD.dismiss(completion: {
                        print("Success LOGIN")
                        print((Auth.auth().currentUser?.uid)!)
//                        self?.dismiss(animated: true, completion: nil)
                        self!.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    })
                   
                }else{
                    print("Wrong")
                    SVProgressHUD.showError(withStatus: "Error Login")
                    return
                }
            }
        }
    }
    
    
    @IBAction func newAccountBtnPressed(_ sender: Any) {
        guard let logoutVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else {return}
        present(logoutVC, animated: true, completion: nil)
        
        
    }
    
}
