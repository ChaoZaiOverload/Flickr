//
//  ImageCollectionViewCell.swift
//  Flickr
//
//  Created by Yu, Huiting on 3/16/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

final class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    func configure(_ url: URL?) {
        imageView.sd_setImage(with: url)
    }
    
    override func prepareForReuse() {
        imageView.sd_cancelCurrentImageLoad()
    }
}
