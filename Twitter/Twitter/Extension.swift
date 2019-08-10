//
//  Extension.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func presentAlert(message:String){
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (actoin) in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}



