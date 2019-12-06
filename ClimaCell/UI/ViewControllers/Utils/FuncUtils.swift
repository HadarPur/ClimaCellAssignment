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
    var mLoadingAlertController : UIAlertController! = nil
    
    public func showAlertActivityIndicator(viewController: UIViewController, msg: String) {
        mLoadingAlertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 80,y: 60, width: 30, height: 30), type: .ballRotateChase, color: .gray, padding: nil)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        mLoadingAlertController.view.addSubview(activityIndicator)
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: mLoadingAlertController.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: mLoadingAlertController.view, attribute: .centerY, multiplier: 1.4, constant: 0)
        NSLayoutConstraint.activate([ xConstraint, yConstraint])
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        let height: NSLayoutConstraint = NSLayoutConstraint(item: mLoadingAlertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 90)
        mLoadingAlertController.view.addConstraint(height);
        viewController.present(self.mLoadingAlertController, animated: true, completion: nil)
    }
    
    public func hideAlertActivityIndicator(viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
}
