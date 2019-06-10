//
//  RoundImageView.swift
//  Lazy
//
//  Created by Kareemchetoos on 2/6/19.
//  Copyright © 2019 Kareem. All rights reserved.
//

import UIKit


class RoundImageView: UIImageView {
   // let imageCashe = NSCache<NSString , UIImage>()
    
    
//    private var _image : UIImage?
//
//    override var image : UIImage? {
//        get {
//            return _image
//        }
//        set{
//            _image = newValue
//            layer.contents = nil
//            guard let image = newValue else {return}
//
//            DispatchQueue.global(qos:.userInitiated).async {
//                let decodedImage = self.decodedImage(image)
//                DispatchQueue.main.async {
//                    self.layer.contents = decodedImage?.cgImage
//                }
//            }
//        }
//    }
//
//    func decodedImage(_ image : UIImage)->UIImage?{
//        guard let newImage = image.cgImage else {return nil}
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: nil, width: newImage.width, height: newImage.height, bitsPerComponent: 8, bytesPerRow: newImage.width * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        context?.draw(newImage, in: CGRect(x: 0, y: 0, width: newImage.width, height: newImage.height))
//        let decodedImage = context?.makeImage()
//        if let decodedImage = decodedImage{
//            return UIImage(cgImage: decodedImage)
//        }
//        return nil
//    }

    override func awakeFromNib() {
  setupRoundImage()
    }
    

    func setupRoundImage(){
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = false
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    deinit {
        print("round Image DELETE")
    }

}
