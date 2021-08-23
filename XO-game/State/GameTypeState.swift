//
//  GameTypeState.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum GameTypes: Int {
    case classic
    case series
}

protocol GameTypeState {
    var gameType: GameTypes { get }
}

class GameType: GameTypeState {
    static var shared = GameType()
    private init() { }
    
    var gameType: GameTypes = .classic
    var activePlayer: Player = .first
}
