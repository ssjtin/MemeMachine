//
//  MemeView.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class MemeView: UIImageView {
    
    let topCaption: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 40)
        tf.textAlignment = .left
        tf.adjustsFontSizeToFitWidth = true
        tf.layer.borderWidth = 3
        tf.layer.borderColor = UIColor.black.cgColor
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.isEnabled = false
        return tf
    }()
    
    let bottomCaption: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 40)
        tf.textAlignment = .left
        tf.adjustsFontSizeToFitWidth = true
        tf.layer.borderWidth = 3
        tf.layer.borderColor = UIColor.black.cgColor
        tf.setLeftPaddingPoints(20)
        tf.setRightPaddingPoints(20)
        tf.isEnabled = false
        return tf
    }()

    override init(image: UIImage?) {
        super.init(image: image)
        
        contentMode = .scaleAspectFill
        layer.borderWidth = 5
        layer.borderColor = UIColor.red.cgColor
        isUserInteractionEnabled = true
        
        self.addSubviewUsingAutoLayout(topCaption, bottomCaption)
        topCaption.topAnchor.constrain(to: self.topAnchor)
        topCaption.leadingAnchor.constrain(to: self.leadingAnchor)
        topCaption.trailingAnchor.constrain(to: self.trailingAnchor)
        topCaption.heightAnchor.constrain(to: 75)
        
        bottomCaption.bottomAnchor.constrain(to: self.bottomAnchor)
        bottomCaption.trailingAnchor.constrain(to: self.trailingAnchor)
        bottomCaption.leadingAnchor.constrain(to: self.leadingAnchor)
        bottomCaption.heightAnchor.constrain(to: 75)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
    


