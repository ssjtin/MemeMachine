//
//  MenuRouter.swift
//  MemeMachine
//
//  Created by Hoang Luong on 11/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class MenuRouter {
    
    enum Destination: String {
        case Popular = "Most Popular Memes"
        case TopVoted = "Top Voted Memes"
        case Camera = "Choose from Phone"
    }
    
    init() {}
    
    func route(to destination: String, fromVC: UIViewController, parameters: Any?) {
        switch destination {
        case Destination.Popular.rawValue:

            let vc = MemeCollectionVC()
            vc.viewModel.beginFetchingImages()
            fromVC.navigationController?.pushViewController(vc, animated: true)
            
        case Destination.TopVoted.rawValue:

            let vc = MemeCollectionVC()
            vc.viewModel.sessionManager.urlString = newUrl
            vc.viewModel.beginFetchingImages()
            fromVC.navigationController?.pushViewController(vc, animated: true)
            
        case Destination.Camera.rawValue:

            let vc = ImagePickerController()
            fromVC.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("default")
        }
    }
    
}
