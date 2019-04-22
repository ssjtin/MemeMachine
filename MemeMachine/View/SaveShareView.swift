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
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "saveArrow"), for: .normal)
        //button.setBackgroundImage(#imageLiteral(resourceName: "saveArrow"), for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = UIStackView.Distribution.fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        
        addSubviewUsingAutoLayout(buttonStackView)
        addSubviewWithConstraints(subview: buttonStackView, topAnchor: self.topAnchor, leadingAnchor: self.leadingAnchor, trailingAnchor: self.trailingAnchor, bottomAnchor: self.bottomAnchor)
        
        saveButton.frame.size = CGSize(width: 65, height: 35)
        
        buttonStackView.addArrangedSubview(shareButton)
        buttonStackView.addArrangedSubview(sendMessageButton)
        buttonStackView.addArrangedSubview(saveButton)
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
