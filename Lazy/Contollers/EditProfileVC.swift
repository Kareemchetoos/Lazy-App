
//
//  EditProfileVC.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/10/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SDWebImage

class EditProfileVC: UIViewController {
    var imagePicker:UIImagePickerController!
    var userData : UserModel?
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var workTxtField: UITextField!
    @IBOutlet weak var profileImage: RoundImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        datePickerView.datePickerMode = .date
        
        
        DataServices.instanse.getUserData(uid: (Auth.auth().currentUser?.uid)!) { (success, myData) in
            if success {
                self.userData = myData
                self.firstNameTxtField.text = self.userData!.firstName
                self.lastNameTxtField.text = self.userData!.lastName
                self.phoneTxtField.text = self.userData!.phone
                self.workTxtField.text = self.userData!.workAt
                self.countryTxtField.text = self.userData!.country
                self.cityTxtField.text = self.userData!.city
                        
                        
                    
                ImageServices.instance.loadImage(imageView: self.profileImage, url: self.userData!.imageURL)
                
            }
        }

    }
    
    @IBAction func addProfileImageBtnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.9605188966, green: 0.5448473096, blue: 0.0003650852886, alpha: 1))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0.08575998992, green: 0.2902765274, blue: 0.4041840136, alpha: 1))
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.show(withStatus: "Saving")
        DataServices.instanse.uploadProfileImage(image: profileImage.image!) { (imageURL) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let selectedDate = dateFormatter.string(from: self.datePickerView.date)
            
            DataServices.instanse.profileData(uid: (Auth.auth().currentUser?.uid)!, data: ["firstName" : self.firstNameTxtField.text! , "lastName" : self.lastNameTxtField.text! , "phone" : self.phoneTxtField.text! , "work" : self.workTxtField.text! , "imageURL" : imageURL!,"country" : self.countryTxtField.text! , "city" : self.cityTxtField.text! , "born" : selectedDate]) { (succes) in
                SVProgressHUD.dismiss()
                print("Data Saved Success")
                self.dismiss(animated: true, completion: nil
                )
            }
        }
        
        
     
    }
    
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension EditProfileVC : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}


