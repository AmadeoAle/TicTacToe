//
//  LoginViewController.swift
//  TicToe
//
//  Created by Amadeo on 20/03/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let mistake = error{
                    print(mistake)
                }else{
                    self.performSegue(withIdentifier: K.login, sender: self)
                }
            }
        }
    }

}
