//
//  ViewController.swift
//  MemeMachine
//
//  Created by Hoang Luong on 3/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemeCollectionVC: UITableViewController {
    
    let cellIdentifier = "imageCell"
    
    let viewModel = MemeCollectionViewModel()
    
    var router: MemeCollectionRouter!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        router = MemeCollectionRouter(viewModel: viewModel)
        
        configureTableView()
        bindViewModel()
    }
    
    func configureTableView() {
        tableView = CustomTableView()
        viewModel.tableView = tableView
        tableView.register(ImageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
    }
    
    func bindViewModel() {
        
        viewModel.chosenImage.asObservable().subscribe(onNext: {
            [unowned self] image in
            self.router.route(to: "MemeGenerator", fromVC: self, parameters: image)
            
        }).disposed(by: disposeBag)
        
        viewModel.images.asObservable().subscribe(onNext: {
            [unowned self] _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ImageCell
        cell.photoView.image = nil
        cell.setLoadingState(to: true)
        viewModel.fetchImage(atRow: indexPath.row) { (image) in
            cell.photoView.image = image
            cell.setLoadingState(to: false)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.images.value.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.width
    }

}

