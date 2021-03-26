//
//  RegisterViewController.swift
//  TicToe
//
//  Created by Amadeo on 20/03/21.
//

import UIKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var alias: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let db = Firestore.firestore() //Inicializamos la DB
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text { //Tienen que tener un valor ambos campos
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let mistake = error{
                    let error = mistake.localizedDescription //Error
                    self.showError(error: error, title: "Error de Autenticación") //PopUp
                    
                }else{
                    self.setJugadorData()
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.register, sender: self)
                }
            }
        }
        
    }
    
    func showError(error:String, title:String){
        let controller = UIAlertController(title: title, message: error, preferredStyle: .alert)
        let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(alert)
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.register {
            let destination = segue.destination as? HomeViewController
            destination?.playerOne = alias.text
        }
    }
    
    func setJugadorData(){
        if let alias = alias.text, let email = emailTextField.text{
            let newDoc = db.collection(K.FStore.collectionName).document()
            newDoc.setData([
                K.FStore.idField : newDoc.documentID ,
                K.FStore.emailField : email ,
                K.FStore.aliasField : alias
            ]){
                (error) in
                if let e = error{
                    print("Error en el registro de los datos \(e) ")
                }else{
                    print("Data guardada exitosamente")
                }
            }
            
           
        }
    }
    
    
    

}
