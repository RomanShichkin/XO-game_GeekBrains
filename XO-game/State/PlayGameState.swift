//
//  PlayGameState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum PlayGameMode: Int {
    case vsPerson
    case vsAI
}

protocol PlayGameState {

    var isMoveCompleted: Bool { get }
    
    var gameMode: PlayGameMode { get }
    
    func begin()
    func addMark(at position: GameboardPosition)
}
