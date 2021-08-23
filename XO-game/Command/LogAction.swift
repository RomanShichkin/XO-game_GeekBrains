//
//  LogAction.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

enum LogAction {
    case playerSetSign(player: Player, position: GameboardPosition)
    case gameFinished(won: Player?)
    case restartGame
}
