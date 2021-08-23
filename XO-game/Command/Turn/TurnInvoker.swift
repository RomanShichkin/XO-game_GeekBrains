//
//  TurnInvoker.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class TurnInvoker {
    static let shared = TurnInvoker()
    private init() { }
    
    private let receiver = TurnReceiver()
    private let bufferSize = 10
    
    private var commands: [TurnCommand] = []
    
    func addTurnCommand(command: TurnCommand) {
        commands.append(command)
        execute()
    }
    
    func clearCommands() {
        commands = []
    }
    
    func execute() {
        guard commands.count >= bufferSize else { return }
        
        let queue = DispatchQueue(label: "com.queue.test", qos: .userInitiated)
        for (index, command) in commands.enumerated() {
            queue.async { [weak self] in
                self?.receiver.placeMarkToBoard(with: command.placeMark, index: index)
            }
        }
    }
}
