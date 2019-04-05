//
//  ImageCell.swift
//  MemeMachine
//
//  Created by Hoang Luong on 4/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    let photoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIView.ContentMode.scaleAspectFit
        return iv
    }()
    
    let topSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.gray
        
        addSubviewUsingAutoLayout(photoView, topSeparator, separator, spinner)
        photoView.topAnchor.constrain(to: topSeparator.bottomAnchor)
        photoView.leadingAnchor.constrain(to: self.leadingAnchor)
        photoView.trailingAnchor.constrain(to: self.trailingAnchor)
        photoView.bottomAnchor.constrain(to: separator.topAnchor)
        
        topSeparator.leadingAnchor.constrain(to: self.leadingAnchor)
        topSeparator.trailingAnchor.constrain(to: self.trailingAnchor)
        topSeparator.topAnchor.constrain(to: self.topAnchor)
        topSeparator.heightAnchor.constrain(to: 5)
        
        separator.leadingAnchor.constrain(to: self.leadingAnchor)
        separator.trailingAnchor.constrain(to: self.trailingAnchor)
        separator.bottomAnchor.constrain(to: self.bottomAnchor)
        separator.heightAnchor.constrain(to: 5)
        
        spinner.centerXAnchor.constrain(to: self.centerXAnchor)
        spinner.centerYAnchor.constrain(to: self.centerYAnchor)
        spinner.heightAnchor.constrain(to: 50)
        spinner.widthAnchor.constrain(to: 50)
        spinner.hidesWhenStopped = true
    }
    
    func setLoadingState(to state: Bool) {
        if state == true {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
