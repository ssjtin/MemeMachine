//
//  MenuVCViewController.swift
//  MemeMachine
//
//  Created by Hoang Luong on 6/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuVC: UICollectionViewController {
    
    let cellId = "cellId"
    let viewModel = MenuViewModel()
    let router = MenuRouter()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(MenuButtonCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = nil
        
        bindViewModel()
    }

    func bindViewModel() {
        //Bind collectionView to data source
        viewModel.dataSource.bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: MenuButtonCell.self)) {
            row, element, cell in
            
            cell.buttonText.text = element.1
            cell.iconView.image = element.0
        }.disposed(by: disposeBag)
        
        //Handle collectionView cell pressed
        collectionView.rx.itemSelected.subscribe(onNext: {
            [unowned self] indexPath in
            let buttonTitle = self.viewModel.dataSource.value[indexPath.row].title
            self.router.route(to: buttonTitle, fromVC: self, parameters: nil)
        }).disposed(by: disposeBag)
        
    }
    
}

extension MenuVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = view.frame.width * 0.4
        return CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 150, left: 25, bottom: 150, right: 25)
    }
    
}
