//
//  MainRouter.swift
//  MemeMachine
//
//  Created by Hoang Luong on 4/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

class MemeCollectionRouter {

    unowned var viewModel: MemeCollectionViewModel
    
    init(viewModel: MemeCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    func route(to destination: String, fromVC: UIViewController, parameters: Any?) {
        switch destination {
        case "MemeGenerator":
            guard let image = parameters as? UIImage else { return }
            let vc = MemeGeneratorVC(memeImage: image)
            let navVC = UINavigationController(rootViewController: vc)
            fromVC.present(navVC, animated: true, completion: nil)
            
        default:
            ()
        }
    }
    
}
