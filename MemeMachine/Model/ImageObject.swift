//
//  ImageObject.swift
//  MemeMachine
//
//  Created by Hoang Luong on 3/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

struct ImageObject: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case imageUrl
        case imageName = "displayName"
    }
    
    let imageUrl: String
    let imageName: String
    
}
