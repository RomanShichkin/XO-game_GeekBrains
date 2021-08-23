//
//  GameEndState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameEndState: PlayGameState {
    
    var gameMode: PlayGameMode

    var isMoveCompleted = false

    public let winner: Player?
    private weak var gameViewController: GameViewController?

    init(winner: Player?, gameViewController: GameViewController, gameMode: PlayGameMode) {
        self.winner = winner
        self.gameViewController = gameViewController
        self.gameMode = gameMode
    }


    func begin() {
        gameViewController?.winnerLabel.isHidden = false
        
        if let winner = winner {
            Logger.shared.log(action: .gameFinished(won: winner))
            gameViewController?.winnerLabel.text = getWinnerName(from: winner)
        } else {
            gameViewController?.winnerLabel.text = "Draw"
            Logger.shared.log(action: .gameFinished(won: nil))
        }
        
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }

    func addMark(at position: GameboardPosition) {}
    
    private func getWinnerName(from winner: Player) -> String {
        return PlayerInfo.getWinnerTitle(gameMode: gameMode, winner: winner)
    }
}
