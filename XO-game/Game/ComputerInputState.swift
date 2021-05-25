//
//  ComputerInputState.swift
//  XO-game
//
//  Created by  Sergei on 24.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final class ComputerInputState: GameState {
  private(set) var isCompleted = false
  private(set) var isDetermineWinner = true
  let player: Player
  private(set) weak var gameViewController: GameViewController?
  private(set) weak var gameboard: Gameboard?
  private(set) weak var gameboardView: GameboardView?
  public let markViewPrototype: MarkView

  init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
    self.player = player
    self.markViewPrototype = markViewPrototype
    self.gameViewController = gameViewController
    self.gameboard = gameboard
    self.gameboardView = gameboardView
 }
  
  func begin() {
    self.gameViewController?.winnerLabel.isHidden = true
    self.gameViewController?.secondPlayerTurnLabel.text = gameViewController?.names.second

    switch self.player {
    case .first:
      self.gameViewController?.firstPlayerTurnLabel.isHidden = false
      self.gameViewController?.secondPlayerTurnLabel.isHidden = false
    case .second:
      self.gameViewController?.firstPlayerTurnLabel.isHidden = false
      self.gameViewController?.secondPlayerTurnLabel.isHidden = false

      guard let position = gameboard?.getFreePositions().randomElement() else { return }
      
      gameboardView?.onSelectPosition?(position)
    }
  }
  
  func addMark(at position: GameboardPosition) {
    Log(.playerInput(player: player, position: position))

    guard let gameboardView = gameboardView,
          gameboardView.canPlaceMarkView(at: position),
          let gameboard = gameboard
    else { return }
    
    let command = PlaceMarkCommand(
      player: player,
      position: position,
      gameboard: gameboard,
      gameboardView: gameboardView)
    
    gameViewController?.commands
      .addComand(command)
      .execute()
    
    isCompleted = true
  }
}
