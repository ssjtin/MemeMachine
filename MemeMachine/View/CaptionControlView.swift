//
//  CaptionControlView.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class CaptionControlView: UIView {
    
    var arrowPad: ArrowPad!
    
    let topCaptionControlButton = UIButton(title: "Top caption", borderWidth: 2, borderColor: .blue)
    let bottomCaptionControlButton = UIButton(title: "Bottom caption", borderWidth: 2, borderColor: .blue)
    let whiteFontButton = UIButton(title: "", borderWidth: 2, borderColor: .black)
    let blackFontButton = UIButton(title: "", borderWidth: 2, borderColor: .white)
    let increaseFontButton = UIButton()
    let decreaseFontButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blue
        
        arrowPad = ArrowPad(frame: CGRect(x: self.frame.width/3, y: 0, width: self.frame.height, height: self.frame.height))
        addSubview(arrowPad)
        
        addSubviewUsingAutoLayout(topCaptionControlButton, bottomCaptionControlButton)
        
        topCaptionControlButton.topAnchor.constrain(to: self.topAnchor)
        topCaptionControlButton.leadingAnchor.constrain(to: self.leadingAnchor)
        topCaptionControlButton.heightAnchor.constrain(to: self.frame.height/2)
        topCaptionControlButton.widthAnchor.constrain(to: self.frame.width/3)
        
        bottomCaptionControlButton.topAnchor.constrain(to: topCaptionControlButton.bottomAnchor)
        bottomCaptionControlButton.leadingAnchor.constrain(to: self.leadingAnchor)
        bottomCaptionControlButton.heightAnchor.constrain(to: self.frame.height/2)
        bottomCaptionControlButton.widthAnchor.constrain(to: self.frame.width/3)
        
        configureFontColorButtons()
        configureFontSizeButtons()
    }
    
    func configureFontColorButtons() {
        let buttonWidth = self.frame.height * 0.4
        whiteFontButton.layer.cornerRadius = buttonWidth/2
        whiteFontButton.backgroundColor = .white
        blackFontButton.layer.cornerRadius = buttonWidth/2
        blackFontButton.backgroundColor = .black
        addSubviewUsingAutoLayout(whiteFontButton, blackFontButton)
        
        whiteFontButton.topAnchor.constrain(to: self.topAnchor, with: 3)
        whiteFontButton.leadingAnchor.constrain(to: arrowPad.trailingAnchor, with: 20)
        whiteFontButton.widthAnchor.constrain(to: buttonWidth)
        whiteFontButton.heightAnchor.constrain(to: buttonWidth)
        
        blackFontButton.bottomAnchor.constrain(to: self.bottomAnchor, with: -3)
        blackFontButton.leadingAnchor.constrain(to: arrowPad.trailingAnchor, with: 20)
        blackFontButton.widthAnchor.constrain(to: buttonWidth)
        blackFontButton.heightAnchor.constrain(to: buttonWidth)
        
    }
    
    func configureFontSizeButtons() {
        let buttonWidth = self.frame.height * 0.5
        increaseFontButton.setImage(#imageLiteral(resourceName: "increaseFont"), for: .normal)
        decreaseFontButton.setImage(#imageLiteral(resourceName: "decreaseFont"), for: .normal)
        addSubviewUsingAutoLayout(increaseFontButton, decreaseFontButton)
        
        increaseFontButton.topAnchor.constrain(to: self.topAnchor)
        increaseFontButton.leadingAnchor.constrain(to: whiteFontButton.trailingAnchor, with: 20)
        increaseFontButton.heightAnchor.constrain(to: buttonWidth)
        increaseFontButton.widthAnchor.constrain(to: buttonWidth)
        
        decreaseFontButton.topAnchor.constrain(to: increaseFontButton.bottomAnchor)
        decreaseFontButton.leadingAnchor.constrain(to: whiteFontButton.trailingAnchor, with: 20)
        decreaseFontButton.heightAnchor.constrain(to: buttonWidth)
        decreaseFontButton.widthAnchor.constrain(to: buttonWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
