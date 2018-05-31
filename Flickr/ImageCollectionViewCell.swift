//
//  ImageCollectionViewCell.swift
//  Flickr
//
//  Created by Yu, Huiting on 3/16/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import UIKit


final class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    var imageLoader: ImageViewLoader = ImageLoader.shared
    
    func configure(_ url: URL?) {
        if let url = url {
            imageLoader.loadImage(with: url, imageView: imageView)
        }
    }
    
    override func prepareForReuse() {
        imageLoader.cancelLoading(for: imageView)
    }
}
