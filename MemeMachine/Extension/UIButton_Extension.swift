//
//  UIButton_Extension.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, borderWidth: CGFloat, borderColor: UIColor) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
