//
//  ArrowPad.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class ArrowPad: UIView {
    
    let upButton = UIButton(type: .custom)
    let downButton = UIButton(type: .custom)
    let leftButton = UIButton(type: .custom)
    let rightButton = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        let downArrow = #imageLiteral(resourceName: "arrowIcon")
        
        backgroundColor = UIColor.black
        
        addSubviewUsingAutoLayout(upButton, downButton, leftButton, rightButton)
        let buttonWidth = self.frame.width * 0.4
        
        upButton.setImage(downArrow.rotate(radians: .pi), for: .normal)
        upButton.topAnchor.constrain(to: self.topAnchor)
        upButton.centerXAnchor.constrain(to: self.centerXAnchor)
        upButton.widthAnchor.constrain(to: buttonWidth)
        upButton.heightAnchor.constrain(to: buttonWidth)
        
        downButton.setImage(downArrow, for: .normal)
        downButton.bottomAnchor.constrain(to: self.bottomAnchor)
        downButton.centerXAnchor.constrain(to: self.centerXAnchor)
        downButton.widthAnchor.constrain(to: buttonWidth)
        downButton.heightAnchor.constrain(to: buttonWidth)
        
        leftButton.setImage(downArrow.rotate(radians: .pi/2), for: .normal)
        leftButton.leadingAnchor.constrain(to: self.leadingAnchor)
        leftButton.centerYAnchor.constrain(to: self.centerYAnchor)
        leftButton.widthAnchor.constrain(to: buttonWidth)
        leftButton.heightAnchor.constrain(to: buttonWidth)
        
        rightButton.setImage(downArrow.rotate(radians: .pi*1.5), for: .normal)
        rightButton.trailingAnchor.constrain(to: self.trailingAnchor)
        rightButton.centerYAnchor.constrain(to: self.centerYAnchor)
        rightButton.widthAnchor.constrain(to: buttonWidth)
        rightButton.heightAnchor.constrain(to: buttonWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
