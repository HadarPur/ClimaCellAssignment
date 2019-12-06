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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true

        mCountries.readAllData {
            print("Done Reading Countries Data")
            self.moveToMainVC()
        }
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

