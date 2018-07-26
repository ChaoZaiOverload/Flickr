//
//  PhotoViewController.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation
import UIKit

import SDWebImage

//TODO: create a 'imageLoader' class that encapsulates the 3rd-party lib like SDwebImage calls so that it's easier to switch between multiple libs.

class PhotoViewController: UIViewController {
    var url: URL?
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.sd_setImage(with: url)
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true)
    }
}
