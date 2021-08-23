//
//  LogCommand.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class LogCommand {
    let action: LogAction
    
    init(action: LogAction) {
        self.action = action
    }
    
    var logMessage: String {
        switch action {
        case .playerSetSign(let player, let position):
            return "\(player) placed mark at position \(position)"
        case .gameFinished(let winner):
            if let winner = winner {
                return "\(winner) won game"
            } else {
                return "Is Draw"
            }
        case .restartGame:
            return "Game was restarted"
        }
    }
}
