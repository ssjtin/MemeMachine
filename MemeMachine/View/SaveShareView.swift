//
//  SaveShareView.swift
//  MemeMachine
//
//  Created by Hoang Luong on 6/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import FacebookShare

class SaveShareView: UIView {
    
    let shareButton = ShareButton<PhotoShareContent>()
    let sendMessageButton = SendButton<PhotoShareContent>()
    
    let saveButton: SaveButtonView = {
        let button = SaveButtonView()
        button.iconView.image = #imageLiteral(resourceName: "saveArrow")
        button.titleLabel.text = "Save"
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 20
        sv.distribution = UIStackView.Distribution.fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        layer.cornerRadius = 15
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        
        addSubviewUsingAutoLayout(buttonStackView)
        addSubviewWithConstraints(subview: buttonStackView, topAnchor: self.topAnchor, leadingAnchor: self.leadingAnchor, trailingAnchor: self.trailingAnchor, bottomAnchor: self.bottomAnchor)
        
        buttonStackView.addArrangedSubview(shareButton)
        buttonStackView.addArrangedSubview(sendMessageButton)
        buttonStackView.addArrangedSubview(saveButton)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
