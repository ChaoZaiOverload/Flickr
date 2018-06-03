//
//  ImageLoader.swift
//  Flickr
//
//  Created by Yu, Huiting on 5/31/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

protocol ImageViewLoader {
    func loadImage(with url: URL, imageView: UIImageView)
    func cancelLoading(for imageView: UIImageView)
}

private class SDloader: ImageViewLoader {
    func loadImage(with url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url, completed: nil)
    }
    func cancelLoading(for imageView: UIImageView) {
        imageView.sd_cancelCurrentImageLoad()
    }
}
extension UIImageView {
    static var imageUrlIdentifier = "imageUrlIdentifier"
    var imageUrl: URL? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.imageUrlIdentifier) as? URL
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIImageView.imageUrlIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
private class SimpleLoader: ImageViewLoader {
    func loadImage(with url: URL, imageView: UIImageView) {
        imageView.imageUrl = url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let img = UIImage(data: data), url == imageView.imageUrl {
                DispatchQueue.main.async {
                    imageView.image = img
                }
                
            } else {
                //default image
                print("image url don't match")
            }
        }.resume()
        
    }
    func cancelLoading(for imageView: UIImageView) {
        imageView.image = nil
    }
}

class ImageLoader {
    static let shared: ImageViewLoader = SimpleLoader()
}
