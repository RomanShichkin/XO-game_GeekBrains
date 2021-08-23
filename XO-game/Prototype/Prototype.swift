//
//  Prototype.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol Copying: AnyObject {
    init(_ protype: Self)
}

extension Copying  {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
