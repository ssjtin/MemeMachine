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
import FacebookShare

class MemeGeneratorVC: UIViewController {
    
    enum Direction {
        case Up, Down, Left, Right
    }
    
    let memeImage: UIImage
    let viewModel = MemeGeneratorViewModel()
    let disposeBag = DisposeBag()
    
    var captionControl: CaptionControlView!
    var saveShareView: SaveShareView?
    
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
            if adjustment < 0 {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                UIView.animate(withDuration: duration!, animations: {
                    self.memeViewCenterYConstraint?.constant = adjustment + (self.memeViewOffset ?? 0.0)
                    self.view.layoutIfNeeded()
                })
            }
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe(onNext: {
            [unowned self] notification in
            if self.memeViewCenterYConstraint?.constant != 0 {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
                UIView.animate(withDuration: duration!, animations: {
                    self.memeViewCenterYConstraint?.constant = self.memeViewOffset ?? 0
                    self.view.layoutIfNeeded()
                })
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    var memeViewHeightConstraint: NSLayoutConstraint?
    
    func configureViews() {
        
        configureMemeView()
        configureCaptionControlView()
    }
    
    var memeViewCenterYConstraint: NSLayoutConstraint?
    var memeViewOffset: CGFloat?
    
    func configureMemeView() {
        let imageRatio = memeImage.size.height/memeImage.size.width
        let screenWidth = UIScreen.main.bounds.size.width
        
        view.addSubviewUsingAutoLayout(memeView)
        
        let viewHeight = screenWidth * imageRatio
        let captionControlMaxY: CGFloat = 88 + 120
        let memeViewMinY = view.frame.midY - viewHeight/2
        let spacing = memeViewMinY - captionControlMaxY
        
        if spacing < 0 {
            memeViewOffset = -spacing
        }
        memeView.centerXAnchor.constrain(to: view.centerXAnchor)
        memeViewCenterYConstraint = memeView.centerYAnchor.constrain(to: view.centerYAnchor)
        if let offset = memeViewOffset {
            memeViewCenterYConstraint?.constant = offset
        }
        memeView.widthAnchor.constrain(to: screenWidth)
        memeView.heightAnchor.constrain(to: screenWidth * imageRatio)
        
        memeView.image = memeImage
    }
    
    func configureCaptionControlView() {
        captionControl = CaptionControlView(frame: CGRect(x: 0, y: 88, width: view.frame.width, height: 120))
        view.addSubview(captionControl)
    }
    
    func showSaveShareView() {
        guard let memeImage = viewModel.memeImage.value else { return }
        
        saveShareView = SaveShareView(frame: CGRect(x: view.frame.midX - 200, y: view.frame.midY - 100, width: 300, height: 100))
        
        view.addSubview(saveShareView!)
        
        let sharePhoto = Photo(image: memeImage, userGenerated: true)
        var content = PhotoShareContent()
        content.photos = [sharePhoto]
        
        saveShareView?.shareButton.content = content
        saveShareView?.sendMessageButton.content = content
        
        let saveGesture = UITapGestureRecognizer()
        saveShareView?.saveButton.addGestureRecognizer(saveGesture)
        
        saveGesture.rx.event.subscribe(onNext: {
            [unowned self] _ in
            UIImageWriteToSavedPhotosAlbum(memeImage, self, #selector(self.image), nil)
        }).disposed(by: disposeBag)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("popping to root")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func handleDiscardMeme() {
        
        let alert = UIAlertController(title: "Finish without saving your fresh meme?", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
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
        
        //Adjust text
        captionControl.whiteFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.applyChanges(for: .SetWhite)
        }).disposed(by: disposeBag)
        
        captionControl.blackFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.applyChanges(for: .SetBlack)
        }).disposed(by: disposeBag)
        
        captionControl.increaseFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.applyChanges(for: .IncreaseFont)
        }).disposed(by: disposeBag)
        
        captionControl.decreaseFontButton.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.viewModel.applyChanges(for: .DecreaseFont)
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
            self.memeView.set(caption: self.memeView.topCaption, toEnabled: isEditing)
            self.captionControl.topCaptionControlButton.setEnabled(to: !isEditing)
        }).disposed(by: disposeBag)
        
        viewModel.isEditingBottomCaption.asObservable().subscribe(onNext: {
            [unowned self] isEditing in
            self.memeView.set(caption: self.memeView.bottomCaption, toEnabled: isEditing)
            self.captionControl.bottomCaptionControlButton.setEnabled(to: !isEditing)
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
            self.showSaveShareView()
        }).disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
            [unowned self] in
            self.handleDiscardMeme()
        }).disposed(by: disposeBag)
        
    }
    
}
