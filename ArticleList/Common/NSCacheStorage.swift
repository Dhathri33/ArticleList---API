//
//  NSCacheStorage.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 10/1/25.
//

import UIKit

class NSCacheStorage {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func getImage(from urlString: NSString) -> UIImage? {
        guard let cachedImage = NSCacheStorage.cache.object(forKey: urlString) else {
            return nil
        }
        return cachedImage
    }
    
    static func setImage(_ image: UIImage, to url: NSString) {
        NSCacheStorage.cache.setObject(image, forKey: url)
    }
    
}
