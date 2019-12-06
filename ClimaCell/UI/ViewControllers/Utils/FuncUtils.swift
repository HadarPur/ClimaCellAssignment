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
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
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
    
    public func showAlertMessage(vc: UIViewController, title: String?, message: String?, cancelButtonTitle: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func showProgressBar(view: UIView, activityIndicator: NVActivityIndicatorView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([ xConstraint, yConstraint])
        activityIndicator.isUserInteractionEnabled = false
        
        activityIndicator.startAnimating()
    }

    
    public func hideProgressBar(activityIndicator: NVActivityIndicatorView) {
        activityIndicator.removeFromSuperview()
    }
}
