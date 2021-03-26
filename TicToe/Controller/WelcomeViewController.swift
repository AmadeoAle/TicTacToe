//
//  WelcomeViewController.swift
//  TicToe
//
//  Created by Amadeo on 20/03/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) //Good practice to call the parent class
        navigationController?.isNavigationBarHidden = false //Cuando pase a otra pantalla aparezca de nuevo
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
