//
//  TurnAction.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

enum TurnAction {
    case firstPlayerTurn(position: GameboardPosition)
    case secondPlayerTurn(position: GameboardPosition)
}
