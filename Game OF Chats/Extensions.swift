//
//  Extensions.swift
//  Game OF Chats
//
//  Created by Parth Lamba on 02/03/18.
//  Copyright © 2018 Parth Lamba. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCacheUsingUrlString(urlString: String) {
        
        //sets the image of the user to nil before cacheing/downloading new image
        self.image = nil
        
        //Checking cache for image
        if let cacheImage = imageCache.object(forKey: urlString as NSString){
            self.image = cacheImage
            return
        }
        
        //Dowload image if cache is not present
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage, forKey: urlString as NSString)
                    self.image = downloadImage
                }
            }
        }).resume()
    }
}
