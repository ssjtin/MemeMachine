//
//  MemeGeneratorViewModel.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//
import RxSwift
import RxCocoa

class MemeGeneratorViewModel {
    
    struct CaptionSettings {
        var fontSize: CGFloat = 30
        var fontcolor: UIColor = .black
    }
    
    let isEditingTopCaption = BehaviorRelay<Bool>(value: false)
    let isEditingBottomCaption = BehaviorRelay<Bool>(value: false)
    
    let topCaptionSettings = BehaviorRelay<CaptionSettings>(value: CaptionSettings())
    
    let bottomCaptionSettings = BehaviorRelay<CaptionSettings>(value: CaptionSettings())
    
    let memeImage = BehaviorRelay<UIImage?>(value: nil)
    
    init() {}
    
    func saveMeme(from view: UIImageView) {
        isEditingTopCaption.accept(false)
        isEditingBottomCaption.accept(false)
        
        memeImage.accept(view.getImageFromVisibleContext())
    }
    
    
    func endEditing() {
        isEditingTopCaption.accept(false)
        isEditingBottomCaption.accept(false)
    }
    
}
