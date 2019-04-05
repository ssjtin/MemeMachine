//
//  UIImageView_Extension.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func getImageFromVisibleContext() -> UIImage {
        
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
//        self.drawHierarchy(in: CGRect(origin: CGPoint.zero, size: self.bounds.size), afterScreenUpdates: true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return image
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { ctx in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
        return image
    }
}
