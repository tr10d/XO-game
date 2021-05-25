//
//  LogAction.swift
//  XO-game
//
//  Created by  Sergei on 21.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public enum LogAction {
  case playerInput(player: Player, position: GameboardPosition)
  case gameFinished(winner: Player?)
  case restartGame
}

public func Log(_ action: LogAction) {
  let command = LogCommand(action: action)
  LoggerInvoker.shared.addLogCommand(command)
}

