//
//  UIUtils.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView


class FuncUtils: NSObject {

    public func showAlertMessage(vc: UIViewController, title: String?, message: String?, cancelButtonTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
