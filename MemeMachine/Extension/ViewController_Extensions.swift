//
//  ViewController_Extensions.swift
//  OneWord
//
//  Created by Hoang Luong on 1/4/19.
//  Copyright © 2019 Hoang Luong. All rights reserved.
//

import UIKit

extension UIViewController {
    static func constructAlert(withTitle title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
}
