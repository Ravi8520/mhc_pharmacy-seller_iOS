//
//  UIImageViewExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Jatan Ambasana on 07/12/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    @discardableResult
    func loadImageFromUrl(urlString: String, placeHolder: UIImage? = nil) -> URLSessionDataTask? {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            
            self.image = cachedImage
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        if let placeholder = placeHolder {
            self.image = placeholder
        }
        
        let task = URLSession.shared.dataTask(
            with: url
        ) { data, response, error in
        
            if let data = data,
               let downloadedImage = UIImage(data: data) {
                
                imageCache.setObject(
                    downloadedImage,
                    forKey: NSString(string: urlString)
                )
                
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
        }
        
        task.resume()
        
        return nil
    }
    
}
