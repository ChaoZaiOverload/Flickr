//
//  PhotoViewController.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

//TODO: create a 'imageLoader' class that encapsulates the 3rd-party lib like SDwebImage calls so that it's easier to switch between multiple libs.

final class PhotoViewController: UIViewController {
  private let url: URL?
  
  private lazy var imageView = UIImageView()
  private lazy var closeButton: UIButton = {
    let b = UIButton()
    b.setTitle("close", for: .normal)
    return b
  }()
  
  init(url: URL?) {
    self.url = url
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.bottom.top.left.right.equalToSuperview()
    }
    view.addSubview(closeButton)
    closeButton.snp.makeConstraints { (make) in
      make.size.height.width.equalTo(44)
      make.top.equalToSuperview().offset(10)
      make.right.equalToSuperview().offset(-10)
    }
    closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    imageView.sd_setImage(with: url)
  }
  
  @objc func dismiss(_ sender: Any) {
    self.dismiss(animated: true)
  }
}
