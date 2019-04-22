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
    
    enum TextAdjustment {
        case IncreaseFont, DecreaseFont, SetWhite, SetBlack
    }
    
    enum Caption {
        case Top, Bottom
    }
    
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
    
    func applyChanges(for adjustment: TextAdjustment) {
        
        var currentSettings: CaptionSettings
        var editingCaption: Caption
        
        if isEditingTopCaption.value {
            currentSettings = topCaptionSettings.value
            editingCaption = .Top
        } else if isEditingBottomCaption.value {
            currentSettings = bottomCaptionSettings.value
            editingCaption = .Bottom
        } else { return }
        
        switch adjustment {
            
        case .IncreaseFont:
            currentSettings.fontSize += 2
        case .DecreaseFont:
            guard currentSettings.fontSize > 1 else { return }
            currentSettings.fontSize -= 2
        case .SetBlack:
            guard currentSettings.fontcolor != .black else { return }
            currentSettings.fontcolor = .black
        case .SetWhite:
            guard currentSettings.fontcolor != .white else { return }
            currentSettings.fontcolor = .white
        }
        
        if editingCaption == .Top {
            topCaptionSettings.accept(currentSettings)
        } else {
            bottomCaptionSettings.accept(currentSettings)
        }
    }
    
    func endEditing() {
        isEditingTopCaption.accept(false)
        isEditingBottomCaption.accept(false)
    }
    
}
