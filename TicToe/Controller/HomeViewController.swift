//
//  HomeViewController.swift
//  TicToe
//
//  Created by Amadeo on 20/03/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var secondPlayer: UITextField!
    var playerOne: String?

    let db = Firestore.firestore() //Inicializamos la DB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        homeLabel.text = ""
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.startGame, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.startGame {
            let destination = segue.destination as? GameViewController
            destination?.second = secondPlayer.text
            destination?.first = playerOne
        }
    }
    
    //Cargando Datos del Jugador - Alias + Partidas
    func loadData(){
        if let email = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).whereField("email", isEqualTo: email).getDocuments(completion: { (doc, error) in
                if error == nil && doc != nil{
                    for document in doc!.documents{
                        let docData = document.data()
                        if let alias = docData[K.FStore.aliasField] as? String{
                            print(alias)
                            DispatchQueue.main.async {
                                self.homeLabel.text = "Hola \(alias)"
                                self.playerOne = alias
                            }
                        }
                    }
                }
            })
            
        }
        
    }
    
    //Salir del Home
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    //Ver partidas jugadas
    
    @IBAction func seeMatchesPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToMatches", sender: self)
        
    }
    

    

}
