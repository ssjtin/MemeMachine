//
//  MemeGeneratorVC.swift
//  MemeMachine
//
//  Created by Hoang Luong on 5/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemeGeneratorVC: UIViewController {
    
    enum Direction {
        case Up, Down, Left, Right
    }
    
    let memeImage: UIImage
    let viewModel = MemeGeneratorViewModel()
    let disposeBag = DisposeBag()
    
    var captionControl: CaptionControlView!
    
    let memeView = MemeView(image: nil)
    
    init(memeImage: UIImage) {
        self.memeImage = memeImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        view.isUserInteractionEnabled = true
        
        configureTapGesture()
        configureNavigationBar()
        configureViews()
        bindViewModel()
        setupKeyboardObservers()
    }
    
    let tapGesture = UITapGestureRecognizer()
    
    func configureTapGesture() {
        memeView.addGestureRecognizer(tapGesture)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe(onNext: {
            [unowned self] notification in
            guard self.viewModel.isEditingBottomCaption.value == true else { return }
            let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
            let adjustment = self.view.frame.maxY - height! - self.memeView.frame.maxY
            print(adjustment)
            if adjustment < 0 {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                UIView.animate(withDuration: duration!, animations: {
                    self.memeViewCenterYConstraint?.constant = adjustment
                    self.view.layoutIfNeeded()
                })
            }
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe(onNext: {
            [unowned self] notification in
            if self.memeViewCenterYConstraint?.constant != 0 {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                UIView.animate(withDuration: duration!, animations: {
                    self.memeViewCenterYConstraint?.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    var memeViewHeightConstraint: NSLayoutConstraint?
    
    func configureViews() {
        
        configureMemeView()
        configureCaptionControlView()
    }
    
    var memeViewCenterYConstraint: NSLayoutConstraint?
    
    func configureMemeView() {
        let imageRatio = memeImage.size.height/memeImage.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        
        view.addSubviewUsingAutoLayout(memeView)
        
        memeView.centerXAnchor.constrain(to: view.centerXAnchor)
        memeViewCenterYConstraint = memeView.centerYAnchor.constrain(to: view.centerYAnchor)
        memeView.widthAnchor.constrain(to: screenWidth)
        memeView.heightAnchor.constrain(to: screenWidth * imageRatio)
        
        memeView.image = memeImage
    }
    
    func configureCaptionControlView() {
        captionControl = CaptionControlView(frame: CGRect(x: 0, y: 88, width: view.frame.width, height: 120))
        view.addSubview(captionControl)
    }
    
    func moveCaption(inDirection direction: Direction) {
        guard viewModel.isEditingBottomCaption.value == true || viewModel.isEditingTopCaption.value == true else { return }
        
        let captionToMove = self.viewModel.isEditingTopCaption.value ? self.memeView.topCaption : self.memeView.bottomCaption
        let startingY = captionToMove.frame.origin.y
        let startingX = captionToMove.frame.origin.x
        
        switch direction {
        case .Up:
            captionToMove.frame.origin = CGPoint(x: startingX, y: startingY-20)
        case .Left:
            captionToMove.frame.origin = CGPoint(x: startingX-20, y: startingY)
        case .Right:
            captionToMove.frame.origin = CGPoint(x: startingX+20, y: startingY)
        case .Down:
            captionToMove.frame.origin = CGPoint(x: startingX, y: startingY+20)
        }
        
    }
    
    func bindViewModel() {
        
        //Tap gesture binding
        tapGesture.rx.event.bind(onNext: {
            [unowned self] tap in
            self.viewModel.endEditing()
        }).disposed(by: disposeBag)
        
        //Caption settings
        viewModel.topCaptionSettings.asObservable().subscribe(onNext: {
            [unowned self] setting in
            self.memeView.topCaption.font = UIFont.boldSystemFont(ofSize: setting.fontSize)
            self.memeView.topCaption.textColor = setting.fontcolor
        }).disposed(by: disposeBag)
        
        viewModel.bottomCaptionSettings.asObservable().subscribe(onNext: {
            [unowned self] setting in
            self.memeView.bottomCaption.font = UIFont.boldSystemFont(ofSize: setting.fontSize)
            self.memeView.bottomCaption.textColor = setting.fontcolor
        }).disposed(by: disposeBag)
        
        //Adjust font color
        captionControl.whiteFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            if self.viewModel.isEditingTopCaption.value == true {
                var currentSettings = self.viewModel.topCaptionSettings.value
                currentSettings.fontcolor = .white
                self.viewModel.topCaptionSettings.accept(currentSettings)
            } else if self.viewModel.isEditingBottomCaption.value == true {
                var currentSettings = self.viewModel.bottomCaptionSettings.value
                currentSettings.fontcolor = .white
                self.viewModel.bottomCaptionSettings.accept(currentSettings)
            }
        }).disposed(by: disposeBag)
        
        captionControl.blackFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            if self.viewModel.isEditingTopCaption.value == true {
                var currentSettings = self.viewModel.topCaptionSettings.value
                currentSettings.fontcolor = .black
                self.viewModel.topCaptionSettings.accept(currentSettings)
            } else if self.viewModel.isEditingBottomCaption.value == true {
                var currentSettings = self.viewModel.bottomCaptionSettings.value
                currentSettings.fontcolor = .black
                self.viewModel.bottomCaptionSettings.accept(currentSettings)
            }
        }).disposed(by: disposeBag)
        
        captionControl.increaseFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            if self.viewModel.isEditingTopCaption.value == true {
                var currentSettings = self.viewModel.topCaptionSettings.value
                currentSettings.fontSize += 2
                self.viewModel.topCaptionSettings.accept(currentSettings)
            } else if self.viewModel.isEditingBottomCaption.value == true {
                var currentSettings = self.viewModel.bottomCaptionSettings.value
                currentSettings.fontSize += 2
                self.viewModel.bottomCaptionSettings.accept(currentSettings)
            }
        }).disposed(by: disposeBag)
        
        captionControl.decreaseFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            if self.viewModel.isEditingTopCaption.value == true {
                var currentSettings = self.viewModel.topCaptionSettings.value
                currentSettings.fontSize -= 2
                self.viewModel.topCaptionSettings.accept(currentSettings)
            } else if self.viewModel.isEditingBottomCaption.value == true {
                var currentSettings = self.viewModel.bottomCaptionSettings.value
                currentSettings.fontSize -= 2
                self.viewModel.bottomCaptionSettings.accept(currentSettings)
            }
        }).disposed(by: disposeBag)
        
        //Move caption controls
        captionControl.arrowPad.upButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.moveCaption(inDirection: .Up)
        }).disposed(by: disposeBag)
        
        captionControl.arrowPad.leftButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.moveCaption(inDirection: .Left)
        }).disposed(by: disposeBag)
        
        captionControl.arrowPad.rightButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.moveCaption(inDirection: .Right)
        }).disposed(by: disposeBag)
        
        captionControl.arrowPad.downButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.moveCaption(inDirection: .Down)
        }).disposed(by: disposeBag)
        
        //Observe currently editing caption
        viewModel.isEditingTopCaption.asObservable().subscribe(onNext: {
            [unowned self] isEditing in
            if isEditing == true {
                self.captionControl.topCaptionControlButton.isEnabled = false
                self.captionControl.topCaptionControlButton.backgroundColor = UIColor.gray
                self.memeView.topCaption.layer.borderColor = UIColor.black.cgColor
                self.memeView.topCaption.isEnabled = true
                self.memeView.topCaption.becomeFirstResponder()
            } else {
                self.captionControl.topCaptionControlButton.isEnabled = true
                self.captionControl.topCaptionControlButton.backgroundColor = UIColor.black
                self.memeView.topCaption.layer.borderColor = UIColor.clear.cgColor
                self.memeView.topCaption.isEnabled = false
            }
        }).disposed(by: disposeBag)
        
        viewModel.isEditingBottomCaption.asObservable().subscribe(onNext: {
            [unowned self] isEditing in
            if isEditing == true {
                self.captionControl.bottomCaptionControlButton.backgroundColor = UIColor.gray
                self.captionControl.bottomCaptionControlButton.isEnabled = false
                self.memeView.bottomCaption.layer.borderColor = UIColor.black.cgColor
                self.memeView.bottomCaption.isEnabled = true
                self.memeView.bottomCaption.becomeFirstResponder()
            } else {
                self.captionControl.bottomCaptionControlButton.isEnabled = true
                self.captionControl.bottomCaptionControlButton.backgroundColor = UIColor.black
                self.memeView.bottomCaption.layer.borderColor = UIColor.clear.cgColor
                self.memeView.bottomCaption.isEnabled = false
            }
        }).disposed(by: disposeBag)
        
        //Controls for selecting captions
        captionControl.topCaptionControlButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.isEditingTopCaption.accept(true)
            self.viewModel.isEditingBottomCaption.accept(false)
        }).disposed(by: disposeBag)
        
        captionControl.bottomCaptionControlButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.isEditingTopCaption.accept(false)
            self.viewModel.isEditingBottomCaption.accept(true)
        }).disposed(by: disposeBag)
        
        //Save meme
        navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: {
            [unowned self] in
            
            self.viewModel.saveMeme(from: self.memeView)
            self.memeView.image = self.viewModel.memeImage.value
            
        }).disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
}
