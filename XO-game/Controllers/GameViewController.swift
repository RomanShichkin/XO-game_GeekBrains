//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private let gameBoard = Gameboard()
    private var currentState: PlayGameState! {
        didSet {
            currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: gameBoard)
    
    private var counter = 0
    
    var gameMode: PlayGameMode?
    var isSecondTurnSeries = false
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        
        setFirstState()
        
        let notificationName = Notification.Name(Notifications.releaseTurnCommand.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(placeMark(_:)), name: notificationName, object: nil)
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.currentState.addMark(at: position)
            if self.currentState.isMoveCompleted {
                
                self.counter += 1
                
                switch GameType.shared.gameType {
                case .classic:
                    self.setNextClassicState()
                case .series:
                    self.setNextSeriesState(position: position)
                }
            }
        }
    }
    
    // MARK: - Настройка UI кнопки
    
    private func setupButtons() {
        ([restartButton, menuButton] as! [UIButton]).forEach { (button) in
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.height/4
        }
    }
    
    // MARK: - (Action): Restart
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        
        Logger.shared.log(action: .restartGame)
        
        gameboardView.clear()
        gameBoard.clear()
        setFirstState()
        TurnInvoker.shared.clearCommands()
        isSecondTurnSeries = false
        gameboardView.isUserInteractionEnabled = true
        GameType.shared.activePlayer = .first
    }
    
    private func setFirstState() {
        guard let gameMode = gameMode else { return }
        
        counter = 0
        let player = Player.first
        currentState = PlayerGameState(player: player, gameViewController: self,
                                       gameBoard: gameBoard, gameBoardView: gameboardView,
                                       markViewPrototype: player.markViewPrototype, gameMode: gameMode)
    }
    
    // MARK: - Classic: Обычная игра
    
    private func setNextClassicState() {
        guard let gameMode = gameMode else { return }
        
        if let winner = referee.determineWinner() {
            currentState = GameEndState(winner: winner, gameViewController: self, gameMode: gameMode)
            return
        }
        
        if counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winner: nil, gameViewController: self, gameMode: gameMode)
            return
        }
        
        
        if let playerInputState = currentState as? PlayerGameState {
            let player = playerInputState.player.next
            
            currentState = PlayerGameState(player: player, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: player.markViewPrototype, gameMode: gameMode)
            
            if gameMode == .vsAI && player == .second {
                let position = gameboardView.generatePosition()
                gameboardView.onSelectPosition?(position)
            }
        }
    }
    
    private func switchPlayerState() {
        if let playerInputState = currentState as? PlayerGameState {
            let player = playerInputState.player.next
            
            currentState = PlayerGameState(player: player, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView,
                                           markViewPrototype: player.markViewPrototype, gameMode: .vsPerson)
        }
    }
    
    // MARK: - Series: Последовательная игра
    
    private func setNextSeriesState(position: GameboardPosition) {
        if counter == 10 { gameboardView.isUserInteractionEnabled = false }
        var command: TurnCommand
        if counter < 5 {
            // Ходит первый игрок
            command = TurnCommand(action: .firstPlayerTurn(position: position))
        } else {
            // Ходит второй игрок
            if !isSecondTurnSeries {
                isSecondTurnSeries = true
                GameType.shared.activePlayer = .second
                gameboardView.clear()
                gameBoard.clear()
                switchPlayerState()
            }
            command = TurnCommand(action: .secondPlayerTurn(position: position))
        }
        
        if counter == 10 {
            gameboardView.clear()
            switchPlayerState()
            isSecondTurnSeries = false
            GameType.shared.activePlayer = .first
        }
        TurnInvoker.shared.addTurnCommand(command: command)
    }
    
    // MARK: - (Action): Back to Menu
    
    @IBAction func backToMenuTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - (Selector) наблюдает за TurnReciever
    @objc func placeMark(_ notification: NSNotification) {
        guard let gameMode = gameMode else { return }
        
        if let dict = notification.userInfo as NSDictionary?,
           let position = dict["position"] as? GameboardPosition,
           let index = dict["index"] as? Int {

//            if index % 2 == 1 {
//                let n = index
//                index += 5
//                if !isSecondTurnSeries {
//                    isSecondTurnSeries = true
//                    DispatchQueue.main.async {
//                        GameType.shared.activePlayer = .second
//                        self.switchPlayerState()
//                    }
//                }
//                index = n
//                isSecondTurnSeries = false
//            }

            
            // Изменение игрока на второго
            if index > 4 {
                if !isSecondTurnSeries {
                    isSecondTurnSeries = true
                    DispatchQueue.main.async {
                        GameType.shared.activePlayer = .second
                        self.switchPlayerState()
                    }
                }
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currentState.addMark(at: position)
            }
            if index >= 9 {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if self.referee.determineAmountOfWinners() == 2 {
                        self.currentState = GameEndState(winner: nil, gameViewController: self, gameMode: gameMode)
                    } else {
                        if let winner = self.referee.determineWinner() {
                            self.currentState = GameEndState(winner: winner, gameViewController: self, gameMode: gameMode)
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
