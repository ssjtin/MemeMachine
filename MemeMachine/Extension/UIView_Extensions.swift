//
//  UIView_Extensions.swift
//  ReadingBuddy
//
//  Created by Hoang Luong on 17/3/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension Optional where Wrapped == UIView {
    
    mutating func reset() {
        self?.removeFromSuperview()
        self = nil
    }
    
}

extension UIView {
    
    func addSubviewWithConstraints(subview: UIView,
                                   topAnchor: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 0,
                                   leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0,
                                   trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0,
                                   bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0,
                                   centerXAnchor: NSLayoutXAxisAnchor? = nil, centerXConstant: CGFloat = 0,
                                   centerYAnchor: NSLayoutYAxisAnchor? = nil, centerYConstant: CGFloat = 0,
                                   width: CGFloat? = nil,
                                   height: CGFloat? = nil) {
        
        if let top = topAnchor {
            subview.topAnchor.constrain(to: top, with: topConstant)
        }
        
        if let leading = leadingAnchor {
            subview.leadingAnchor.constrain(to: leading, with: leadingConstant)
        }
        
        if let trailing = trailingAnchor {
            subview.trailingAnchor.constrain( to: trailing, with: trailingConstant)
        }
        
        if let bottom = bottomAnchor {
            subview.bottomAnchor.constrain(to: bottom, with: bottomConstant)
        }
        
        if let centerX = centerXAnchor {
            subview.centerXAnchor.constrain(to: centerX, with: centerXConstant)
        }
        
        if let centerY = centerYAnchor {
            subview.centerYAnchor.constrain(to: centerY, with: centerYConstant)
        }
        
        if let widthConstant = width {
            subview.widthAnchor.constrain(to: widthConstant)
        }
        
        if let heightConstant = height {
            subview.heightAnchor.constrain(to: heightConstant)
        }
        
    }
    
}
