//
//  ViewController.swift
//  TicToe
//
//  Created by Amadeo on 8/03/21.
//

import UIKit
import Firebase

class GameViewController: UIViewController {

    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var turnoLabel: UILabel!
    //Lista de botones 
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    
    @IBOutlet weak var newGameButton: UIButton!
    var first: String?
    var second: String?
    
    var juego = TicToeBrain() //Seteamos jugadores y tablero
    var referencesButton = [Int:UIButton]()
    
    let db = Firestore.firestore()
    
    //Tenemos una nueva partida
    var partida = Partida()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        juego.jugadores[0].name = first ?? "Jugador 1"
        juego.jugadores[1].name = second!
        
        updateUI()
        newGameButton.isHidden = true
        winLabel.isHidden = true
        referencesButton = [1:b1, 2:b2, 3:b3, 4:b4, 5:b5, 6:b6, 7:b7, 8:b8, 9:b9]
        for i in referencesButton{
            i.value.setTitleColor(.systemPurple, for: .normal)
        }
        
        //Cambiamos configuración
        partida.rival = second!
    }
    
    @IBAction func casillaPressed(_ sender: UIButton) {
        let casilla = sender.titleLabel!.text!
        if juego.constante > 0 && juego.checkWinner() == 2 {
            juego.duringMatch(casilla: casilla)
            if juego.valorRep != true {
                sender.setTitle(juego.jugadores[juego.indice].simbol, for: .normal)
                sender.setTitleColor(.white, for: .normal)
                juego.modo()
            }
        }
        updateUI()
    }
    @IBAction func newGamePressed(_ sender: UIButton) {
        //Reiniciamos match
        juego.repetir() //Datos del jugador
        reinicioBotones() //Tablero
        juego = TicToeBrain() //Crea un nuevo juego
        
        updateUI()
        newGameButton.isHidden = true
        winLabel.isHidden = true
    }
    
    
    func updateUI(){
        turnoLabel.text! = "Turno: \(juego.jugadores[juego.indice].name)"

        if juego.constante == 0 || juego.checkWinner() != 2 {
            //Variables de data para firestore
            let result = juego.checkWinner()
            let rival = partida.rival
            setPartida(rival: rival, result: result)
            
            winLabel.isHidden = false
            if juego.checkWinner() != 2 {
                winLabel.text! = "Gana  \(juego.jugadores[juego.checkWinner()].name)"
                pintarGanador(arreglo: juego.fichaGanadora)
            }else{
                winLabel.text! = "NO hubo ganador"
            }
            newGameButton.isHidden = false
        }
    }
    
    func reinicioBotones(){
        
        //Datos de la tabla
        b1.setTitle("1", for: .normal)
        b2.setTitle("2", for: .normal)
        b3.setTitle("3", for: .normal)
        b4.setTitle("4", for: .normal)
        b5.setTitle("5", for: .normal)
        b6.setTitle("6", for: .normal)
        b7.setTitle("7", for: .normal)
        b8.setTitle("8", for: .normal)
        b9.setTitle("9", for: .normal)

        for i in referencesButton {
            i.value.backgroundColor = UIColor.systemPurple
            i.value.setTitleColor(.systemPurple, for: .normal)
        }
    }
    
    func pintarGanador(arreglo:[Int]){
        for i in arreglo {
            for j in referencesButton{
                if i == j.key {
                    j.value.backgroundColor = UIColor.systemRed
                }
            }
        }
    }

    
    //Guardar las partidas jugadas
    func setPartida(rival:String, result: Int){
        var id: String=""
        if let email = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).whereField("email", isEqualTo: email).getDocuments(completion: { (doc, error) in
                if error == nil && doc != nil{
                    for document in doc!.documents{
                        let docData = document.data()
                        if let alias = docData[K.FStore.aliasField] as? String{
                            print(alias)
                            id =  docData[K.FStore.idField] as! String
                            let newDoc = self.db.collection(K.FStore.collectionName).document(id).collection("partidas").document()
                            newDoc.setData([
                                K.FStore.idField : newDoc.documentID ,
                                "rival" : rival ,
                                "result" : result
                            ]){
                                (error) in
                                if let e = error{
                                    print("Error en el registro de los datos \(e) ")
                                }else{
                                    print("Data guardada de la partida exitosamente!")
                                }
                            }
                            print(id)
                        }
                    }
                }
            })
        }
    }
        
    

    

}

