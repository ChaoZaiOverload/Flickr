//
//  Photo.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "url_s"
    }
}
