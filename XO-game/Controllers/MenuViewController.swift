//
//  MenuViewController.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var gameModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var gameTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playButton: UIButton!
    
    private let startGameSegueIdentifier = "showGame"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlayButton()
    }
    
    private func setupPlayButton() {
        playButton.layer.masksToBounds = true
        playButton.layer.cornerRadius = playButton.frame.height/4
    }
    
    // MARK: - (Action): Play
    @IBAction func playButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: startGameSegueIdentifier, sender: self)
    }
    
    // MARK: - (Action): Изменение значения в gameTypeSegmentedControl
    @IBAction func gameTypeValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gameModeSegmentedControl.isEnabled = true
        case 1:
            gameModeSegmentedControl.isEnabled = false
            gameModeSegmentedControl.selectedSegmentIndex = 0
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case startGameSegueIdentifier:
            guard let gameViewController = segue.destination as? GameViewController,
                  let gameMode = PlayGameMode(rawValue: gameModeSegmentedControl.selectedSegmentIndex),
                  let gameType = GameTypes(rawValue: gameTypeSegmentedControl.selectedSegmentIndex) else { return }
            GameType.shared.gameType = gameType
            gameViewController.gameMode = gameMode
        default: break
        }
    }
}
