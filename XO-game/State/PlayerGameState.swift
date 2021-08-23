//
//  PlayerGameState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerGameState: PlayGameState {
    
    var gameMode: PlayGameMode

    var isMoveCompleted: Bool = false
    
    public let player: Player
    private weak var gameViewController: GameViewController?
    private weak var gameBoard: Gameboard?
    private weak var gameBoardView: GameboardView?
    
    public let markViewPrototype: MarkView
    
    init(player: Player, gameViewController: GameViewController, gameBoard: Gameboard, gameBoardView: GameboardView, markViewPrototype: MarkView, gameMode: PlayGameMode) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markViewPrototype = markViewPrototype
        self.gameMode = gameMode
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.firstPlayerTurnLabel.text = PlayerInfo.getFirstPlayerTitle(gameMode: gameMode)
        gameViewController?.secondPlayerTurnLabel.text = PlayerInfo.getSecondPlayerTitle(gameMode: gameMode)
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView else {
            return
        }
        
        if !gameBoardView.canPlaceMarkView(at: position) {
            guard GameType.shared.gameType == .series,
                  GameType.shared.activePlayer == .second else {
                isMoveCompleted = false
                return
            }
            gameBoardView.removeMarkView(at: position)
        }
        
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        
        gameBoard?.setPlayer(player, at: position)
        
        gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)
        
        isMoveCompleted = true
    }
}
