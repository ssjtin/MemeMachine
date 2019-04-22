//
//  UploadVC.swift
//  MemeMachine
//
//  Created by Hoang Luong on 6/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import FacebookShare
import RxSwift
import RxCocoa

class UploadVC: UIViewController {
    
    let memeImage: UIImage
    
    let shareButton = ShareButton<PhotoShareContent>()
    
    let disposeBag = DisposeBag()

    init(memeImage: UIImage) {
        self.memeImage = memeImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviewUsingAutoLayout(shareButton)
        shareButton.centerXAnchor.constrain(to: view.centerXAnchor)
        shareButton.centerYAnchor.constrain(to: view.centerYAnchor)
        shareButton.heightAnchor.constrain(to: 50)
        shareButton.widthAnchor.constrain(to: 120)
        shareButton.isUserInteractionEnabled = true
        
        let sharePhoto = Photo(image: memeImage, userGenerated: true)
        var content = PhotoShareContent()
        content.photos = [sharePhoto]
        
        shareButton.content = content
    }
    
    func share() {
        
        let sharePhoto = Photo(image: memeImage, userGenerated: true)
        var content = PhotoShareContent()
        content.photos = [sharePhoto]
        
        let shareDialog = ShareDialog(content: content)
        
        do {
            try shareDialog.show()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

}


