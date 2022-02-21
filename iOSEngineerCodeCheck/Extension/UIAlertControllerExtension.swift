//
//  UIAlertControllerExtension.swift
//  iOSEngineerCodeCheck
//
//  Created by Kazuki Takeda on 2022/02/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func createOKAlert(title: String, message: String, vc: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            vc.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        return alert
    }
}
