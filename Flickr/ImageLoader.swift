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

class ImageLoader {
    static let shared: ImageViewLoader = SDloader()
}
