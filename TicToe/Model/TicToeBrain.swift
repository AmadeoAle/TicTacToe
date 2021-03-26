//
//  TicToeBrain.swift
//  TicToe
//
//  Created by Amadeo on 8/03/21.
//

import Foundation
struct TicToeBrain{
    var fichasTotal = [1,2,3,4,5,6,7,8,9]
    let posibilidades = [[1,2,3],[1,4,7],[4,5,6],[2,5,8], [7,8,9], [3,6,9], [1,5,9], [3,5,7]]
    
    var jugadores = [
        Jugador(name: "Jugador1", simbol:"X"),
        Jugador(name: "Jugador2", simbol: "O")
    ]
    
    var indice = 0
    var condicion = false
    var valorRep = false
    var fichaGanadora = [Int]()
    

    
    func validar(num:Int)->Bool{
        if fichasTotal.count>0 {
            if jugadores[indice].fichas.count < 6 {
                if fichasTotal.contains(num) {
                    return true
                }
                else{
                    return false
                }
            }else{
                return false
            }
        }else{
            return false
        }
        
    }
    
    mutating func checkWinner()->Int{ //Para verificar si su conjunto de fichas coincide con algún patrón para GANAR
        for j in 0...1{
            for i in posibilidades{
                for k in jugadores[j].arrayProvFichas {
                    if k == i {
                        fichaGanadora = i
                        return j
                    }
                }
            }
        }
        return 2
    }
    
    mutating func verificarArreglos(){
        var arrayTotal = [[Int]]()
        let cont = jugadores[indice].fichas.count
        if cont<3 {
            print("El jugador aún no llega a 3")
        }else{
            for i in jugadores[indice].fichas {
                let fijo = jugadores[indice].fichas.firstIndex(of: i)!
                let cont2 = cont - 2
                var avance = 0
                for _ in 0..<cont2 {
                    var arrayNuevo = [Int]()
                    var inicio = fijo + avance
                    for k in 0..<3 {
                        if k==0 {
                            arrayNuevo.append(jugadores[indice].fichas[fijo])
                        }else{
                            if inicio >= cont {
                                /*if inicio == 6 {
                                    inicio = 1
                                }else if inicio == 7 {
                                    inicio = 2
                                }else{
                                    inicio = 0
                                } */
                                inicio = exceso(inicio:inicio,cont:cont)
                                
                            }
                            arrayNuevo.append(jugadores[indice].fichas[inicio])
                        }
                        inicio = inicio+1
                    }
                    arrayTotal.append(arrayNuevo)
                    avance += 1
                }
            }
        }
        jugadores[indice].arrayProvFichas = ordenarArreglos(arrayTotal: arrayTotal)

    }
    
    func exceso(inicio:Int, cont:Int)->Int{
        if inicio==cont {
            return 0
        }else{
            return inicio - cont
        }
    }
    func ordenarArreglos(arrayTotal:[[Int]]) -> [[Int]]{
        var arrayVacio = [[Int]]()
        for i in arrayTotal{
            let sortedArray = i.sorted()
            if !arrayVacio.contains(sortedArray) {
                arrayVacio.append(sortedArray)
            }
        }
        return arrayVacio
    }
    
    //
    
    func repeticion(casilla:String)->Bool{//Para verificar que no se pose sobre una ficha ya seleccionada por el otro jugador
        if casilla == "X" || casilla == "O" {
           return true
        }else{
            return false
        }
    }
    
    mutating func match(number:Int){
        let index = fichasTotal.firstIndex(of: number)!
        fichasTotal.remove(at: index)
    }
    
    var constante = 9
    mutating func procesar(number:Int){
        jugadores[indice].fichas.append(number)
        match(number: number)
        constante -= 1
        if constante <= 5 {
            verificarArreglos()
        }
        jugadores[indice].conteo += 1
    }
    
    mutating func modo(){
        if indice == 1{
            indice = 0
        }else{
            indice = 1
        }
    }
    
    mutating func duringMatch(casilla:String){
            if repeticion(casilla: casilla) == true{
                valorRep = true
                print("Casilla repetida, elija otra!")
            }else{
                valorRep = false
                condicion = validar(num: Int(casilla)!)
            }
            
            if condicion == true {
                procesar(number: Int(casilla)!)
                condicion = false
               
            }
        
    }
    
    mutating func repetir(){
            //Datos guardadados del jugador
            for i in 0...1{
                var jugador = jugadores[i]
                jugador.fichas = [Int]()
                jugador.arrayProvFichas = [[Int]]()
                jugador.conteo = 0
            }
            //Datos de la partida
            constante = 9
            indice = 0
            condicion = false
            fichasTotal = [1,2,3,4,5,6,7,8,9]
        
    }


}
