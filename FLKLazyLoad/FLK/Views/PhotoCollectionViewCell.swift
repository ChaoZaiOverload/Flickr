//
//  PhotoCollectionViewCell.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCollectionViewCellReuseIdentifier"
    
    @IBOutlet private var imageView: UIImageView!
    private var url: URL?
    
    func configure(url: URL?, shouldLoad: Bool) {
        imageView.image = nil
        self.url = url
        if !shouldLoad {
            return
        }
        // don't use cache
        SDWebImageDownloader.shared().downloadImage(with: url, options: .ignoreCachedResponse, progress: nil) { [imageView] (img, data, err, res) in
            imageView?.image = img
        }
    }
    
    func reloadImage() {
        SDWebImageDownloader.shared().downloadImage(with: url, options: .ignoreCachedResponse, progress: nil) { [imageView] (img, data, err, res) in
            imageView?.image = img
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
