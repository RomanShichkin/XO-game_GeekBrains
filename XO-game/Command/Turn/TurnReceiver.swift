//
//  TurnReceiver.swift
//  XO-game
//
//  Created by Роман Шичкин on 22.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class TurnReceiver {
    func placeMarkToBoard(with position: GameboardPosition, index: Int) {
        Thread.sleep(forTimeInterval: 1.0)
        let userDict: [String: Any] = ["position": position, "index": index]
        NotificationCenter.default.post(name: Notification.Name(Notifications.releaseTurnCommand.rawValue), object: nil, userInfo: userDict)
    }
}
