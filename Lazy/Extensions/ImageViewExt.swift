//
//  File.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/11/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit

let imageCashe = NSCache<NSString , UIImage>()
extension UIImageView {
    
    func loadImageUsingUrlString(urlString :String){
        let urlPath = URL.init(string: urlString)
        image = nil
        
        if let imageFromCashe = imageCashe.object(forKey: urlString as NSString) {
            self.image = imageFromCashe
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: urlPath!) { (data, url, error) in
            guard let data = data else{return}
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCashe = UIImage(data: data)
                self.image = imageToCashe
            }
            
        }
        dataTask.resume()
    }
}

