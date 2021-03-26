//
//  Constants.swift
//  TicToe
//
//  Created by Amadeo on 20/03/21.
//

import Foundation

struct K{
    static let register = "RegisterToHome"
    static let login = "LoginToHome"
    static let startGame = "HomeToGame"
    static let partidas = "goToMatches"
    static let matchCell = "partidaCell"
    
    struct FStore {
        static var collectionName = "jugador"
        static var idField = "id"
        static var emailField = "email"
        static var aliasField = "alias"
        
    }
}
