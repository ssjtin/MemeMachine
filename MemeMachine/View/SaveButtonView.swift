//
//  SaveButtonView.swift
//  MemeMachine
//
//  Created by Hoang Luong on 6/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class SaveButtonView: UIView {
    
    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
        addSubviewUsingAutoLayout(iconView, titleLabel)
        iconView.topAnchor.constrain(to: self.topAnchor)
        iconView.leadingAnchor.constrain(to: self.leadingAnchor)
        iconView.heightAnchor.constrain(to: self.frame.height)
        iconView.widthAnchor.constrain(to: self.frame.height)
        
        titleLabel.topAnchor.constrain(to: self.topAnchor)
        titleLabel.leadingAnchor.constrain(to: iconView.trailingAnchor)
        titleLabel.trailingAnchor.constrain(to: self.trailingAnchor)
        titleLabel.bottomAnchor.constrain(to: self.bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
