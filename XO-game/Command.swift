//
//  Command.swift
//  XO-game
//
//  Created by  Sergei on 25.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol Command {
  var player: Player { get }
  func execute()
}

class PlaceMarkCommand: Command {
  let player: Player
  let position: GameboardPosition
  let gameboard: Gameboard
  let gameboardView: GameboardView
  let forcePlaceMark: Bool
  
  init(player: Player, position: GameboardPosition, gameboard: Gameboard, gameboardView: GameboardView, forcePlaceMark: Bool = false) {
    self.player = player
    self.position = position
    self.gameboard = gameboard
    self.gameboardView = gameboardView
    self.forcePlaceMark = forcePlaceMark
  }

  func execute() {
    gameboard.setPlayer(player, at: position)
    switch forcePlaceMark {
    case true:
      gameboardView.placeMarkViewForce(player.markViewPrototype.copy(), at: position)
    case false:
      gameboardView.placeMarkView(player.markViewPrototype.copy(), at: position)
    }
  }
}

class CommandInvoker {
  private var commands = [Command]()
  
  func addComand(_ command: Command) -> Self {
    commands.append(command)
    return self
  }
  
  func execute() {
    commands.forEach { $0.execute() }
    commands.removeAll()
  }
  
  func count(for player: Player) -> Int {
    commands.filter { $0.player == player}.count
  }
}
