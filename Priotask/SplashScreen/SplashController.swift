//
//  SplashController.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import UIKit

class SplashController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.performSegue(withIdentifier: "OpenMenu", sender: nil)
        }
    }
}
