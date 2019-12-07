//
//  ViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit

// The first VC that loading the all capital data with singleton
class LoadingViewController: UIViewController {

    let mCountries = Countries.shared
    let utils = FuncUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        readAllData()
    }
    
    func readAllData() {
        mCountries.readAllData(callback: {
            print("Done Reading Countries Data, Move to Main VC.")
            self.moveToMainVC()
        } , callbackError: {
            DispatchQueue.main.async {
                FuncUtils().showAlertMessage(vc: self, title: "Some error has occurred", message: "There is a problem to read the countries, please try later.", cancelButtonTitle: "Ok")
            }
        })
    }
    
    func moveToMainVC() {
        let deadlineTime = DispatchTime.now() + .seconds(2)

        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [ weak self] in
            self?.dismiss(animated: false, completion: nil)
        })
    }
}

