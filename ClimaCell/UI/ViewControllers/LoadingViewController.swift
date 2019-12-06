//
//  ViewController.swift
//  ClimaCell
//
//  Created by Hadar Pur on 06/12/2019.
//  Copyright © 2019 Hadar Pur. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    let mCountries = Countries.shared
    let utils = FuncUtils()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

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
        let deadlineTime = DispatchTime.now() + .seconds(1)

        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            
            self.navigationController?.pushViewController(mainVC, animated: false)
        })
    }
}

