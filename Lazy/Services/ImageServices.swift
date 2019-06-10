//
//  ImageServices.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/11/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit
import SDWebImage

class ImageServices {
    static let instance = ImageServices()
    
    let cache = NSCache<NSString , UIImage>()
    
    func displayImage(withUrl  urlString : String , completion : @escaping(_ image : UIImage)->()){
        
        let urlPath = URL.init(string: urlString)
         let dataTask = URLSession.shared.dataTask(with: urlPath!) { (data, url, error) in
            var downloadedImage:UIImage?
            guard let data = data else{return}
            downloadedImage = UIImage(data: data)
            if downloadedImage != nil {
                ImageServices.instance.cache.setObject(downloadedImage!, forKey: (urlPath?.absoluteString as NSString?)!)
            }else{
                print(error.debugDescription)
            }
            
            
            DispatchQueue.main.async {
                completion(downloadedImage!)
                
            }
            
        }
        dataTask.resume()
        
    }
    
    
    
    func setImages(StringImage imageString : String , completion : @escaping(_ image : UIImage)->()){
        if let image = ImageServices.instance.cache.object(forKey: imageString as NSString){
            completion(image)
        }else{
            ImageServices.instance.displayImage(withUrl: imageString , completion: completion)
        }
    }
    
    func loadImage(imageView : UIImageView , url : String) {
        
        guard let imageURL = URL(string: url) else {return}
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: imageURL)
    }

    
}
