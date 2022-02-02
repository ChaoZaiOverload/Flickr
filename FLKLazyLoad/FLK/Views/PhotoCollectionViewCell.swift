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
  
  private lazy var imageView = UIImageView()
  private var url: URL?
  
  required init?(coder: NSCoder) {
    fatalError("not used")
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.bottom.top.right.left.equalToSuperview()
    }
  }
  
  func configure(url: URL?, shouldLoad: Bool) {
    imageView.image = nil
    self.url = url
    if !shouldLoad {
      return
    }
    // don't use cache
    SDWebImageDownloader.shared().downloadImage(with: url, options: .ignoreCachedResponse, progress: nil) { [imageView] (img, data, err, res) in
      guard let url = url, url == self.url else {
        return
      }
      imageView.image = img
    }
  }
  
  func reloadImage() {
    SDWebImageDownloader.shared().downloadImage(with: url, options: .ignoreCachedResponse, progress: nil) { [imageView] (img, data, err, res) in
      imageView.image = img
    }
  }
  
  override func prepareForReuse() {
    imageView.image = nil
  }
}
