//
//  MainViewModel.swift
//  MemeMachine
//
//  Created by Hoang Luong on 3/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import RxSwift
import RxCocoa

let imageCache = NSCache<NSString, UIImage>()

class MemeCollectionViewModel {
    
    weak var tableView: UITableView? {
        didSet {
            bindToView()
        }
    }
    
    let disposeBag = DisposeBag()
    
    let sessionManager = SessionManager()
    
    var currentPage: Int = 0
    var isLoading: Bool = false
    
    let images = BehaviorRelay<[ImageObject]>(value: [ImageObject]())
    
    let chosenImage = BehaviorRelay<UIImage?>(value: nil)

    func beginFetchingImages() {
        fetchImages(forPage: currentPage) { (images) in
            self.images.accept(images)
        }
    }
    
    func bindToView() {
        
        tableView!.rx.didEndDragging.subscribe(onNext: {
            [unowned self] _ in
            guard let tableView = self.tableView else { return }
            
            let currentOffset = tableView.contentOffset.y
            let maximumOffset = tableView.contentSize.height - tableView.frame.size.height
            
            if maximumOffset - currentOffset <= 10.0 {
                self.loadMore()
            }
        }).disposed(by: disposeBag)

        tableView!.rx.itemSelected.subscribe(onNext: {
            [unowned self] indexPath in
            
            let cell = self.tableView!.cellForRow(at: indexPath) as! ImageCell
            self.chosenImage.accept(cell.photoView.image!)
        }).disposed(by: disposeBag)

    }
    
    func fetchImages(forPage page: Int, completion: @escaping ([ImageObject]) -> ()) {

        sessionManager.fetchImages(pageIndex: currentPage) { (images) in
            completion(images)
        }
    }
    
    func fetchImage(atRow row: Int, completion: @escaping (UIImage) -> ()) {
        sessionManager.retrieveImage(using: images.value[row]) { (image, error) in
            if let image = image {
                completion(image)
            }
        }
    }
    
    func loadMore() {
        isLoading = true
        
        currentPage += 1
        fetchImages(forPage: currentPage) { [unowned self](fetchedImages) in
            var newImagesArray = self.images.value
            newImagesArray.append(contentsOf: fetchedImages)
            self.images.accept(newImagesArray)
            self.isLoading = false
            
        }
    }
    
//    func cellHeightFor(_ row: Int) -> CGFloat {
//        let image = images.value[row]
//
//        let ratio = image.size.height/image.size.width
//        let cellWidth = UIScreen.main.bounds.width
//        return ratio * cellWidth
//    }

}
