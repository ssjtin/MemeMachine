//
//  String_Extension.swift
//  OneWord
//
//  Created by Hoang Luong on 29/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension String {
    mutating func decodeForUrl() {
        self = self.replacingOccurrences(of: " ", with: "%20")
    }
}
