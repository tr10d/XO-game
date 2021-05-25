//
//  GameState.swift
//  XO-game
//
//  Created by  Sergei on 21.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public protocol GameState {
  var isCompleted: Bool { get }
  var isDetermineWinner: Bool { get }

  func begin()
  func addMark(at position: GameboardPosition)
}
