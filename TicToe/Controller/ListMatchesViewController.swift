//
//  ListMatchesViewController.swift
//  TicToe
//
//  Created by Amadeo on 26/03/21.
//

import UIKit
import Firebase

class ListMatchesViewController: UITableViewController {
    
    var partidas = [Partida]()
    let db = Firestore.firestore()

//    @IBOutlet weak var titleCell: UILabel!
//    @IBOutlet weak var subtitleCell: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Partidas jugadas"
       
        loadData()

        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return partidas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partidaCell", for: indexPath)
        let rival = partidas[indexPath.row].rival
        let result = partidas[indexPath.row].match
        
        if result == 2 {
            cell.textLabel?.text = "Juego contra \(rival)"
            cell.detailTextLabel?.text = "Partida empatada"
            cell.detailTextLabel?.textColor = .systemGray
        }else if result == 0{
            cell.textLabel?.text = "Juego contra \(rival)"
            cell.detailTextLabel?.text = "Partida ganada"
            cell.detailTextLabel?.textColor = .systemGreen
        }else{
            cell.textLabel?.text = "Juego contra \(rival)"
            cell.detailTextLabel?.text = "Partida perdida"
            cell.detailTextLabel?.textColor = .systemRed
        }

        return cell
    }
    
    //Guardar las partidas jugadas
    func loadData(){
        var id: String=""
        if let email = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).whereField("email", isEqualTo: email).getDocuments(completion: { (doc, error) in
                if error == nil && doc != nil{
                    for document in doc!.documents{
                        let docData = document.data()
                        if let alias = docData[K.FStore.aliasField] as? String{
                            print(alias)
                            id =  docData[K.FStore.idField] as! String
                            self.db.collection(K.FStore.collectionName).document(id).collection("partidas")
                                .addSnapshotListener { (querySnapshot, error) in
                                    self.partidas = []
                                    if let e = error{
                                        print("Error en la lectura de datos - error: \(e)")
                                    }else{
                                        if let snapDoc = querySnapshot?.documents{
                                            for doc in snapDoc{
                                                let data = doc.data()
                                                if let rivalData = data["rival"] as? String, let resultData = data["result"] as? Int{
                                                    let newPartida = Partida(rival: rivalData, match: resultData)
                                                    self.partidas.append(newPartida)
                                                    
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                        let indexPath = IndexPath(row: self.partidas.count-1, section: 0)
                                                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
            })
        }
    }
    
    
//    //Cargando Datos del Jugador - Alias + Partidas
//    func loadData(){
//        if let email = Auth.auth().currentUser?.email{
//            db.collection(K.FStore.collectionName).whereField("email", isEqualTo: email).getDocuments(completion: { (doc, error) in
//                if error == nil && doc != nil{
//                    for document in doc!.documents{
//                        let docData = document.data()
//                        if let alias = docData[K.FStore.aliasField] as? String{
//                            print(alias)
//                            DispatchQueue.main.async {
//                                self.homeLabel.text = "Hola \(alias)"
//                                self.playerOne = alias
//                            }
//                        }
//                    }
//                }
//            })
//
//        }
//
//    }

}
