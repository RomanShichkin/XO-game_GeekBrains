//
//  PlayerInfo.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

struct PlayerInfo {
    static func getFirstPlayerTitle(gameMode: PlayGameMode) -> String {
        switch gameMode {
        case .vsAI:
            return "Your turn"
        case .vsPerson:
            return "1st player turn"
        }
    }
    
    static func getSecondPlayerTitle(gameMode: PlayGameMode) -> String {
        switch gameMode {
        case .vsAI:
            return "AI thinking"
        case .vsPerson:
            return "2nd player turn"
        }
    }
    
    static func getWinnerTitle(gameMode: PlayGameMode, winner: Player) -> String {
        switch gameMode {
        case .vsAI:
            switch winner {
            case .first:
                return "You win!"
            case .second:
                return "You lose!"
            }
        case .vsPerson:
            switch winner {
            case .first:
                return "1st player wins!"
            case .second:
                return "2nd player wins!"
            }
        }
    }

}
