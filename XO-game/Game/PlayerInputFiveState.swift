//
//  PlayerInputFiveState.swift
//  XO-game
//
//  Created by  Sergei on 24.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final public class PlayerInputFiveState: GameState {
  public private(set) var isCompleted = false
  public private(set) var isDetermineWinner = false
  public let player: Player
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
  
  public func begin() {
    self.gameViewController?.winnerLabel.isHidden = true
    self.gameViewController?.secondPlayerTurnLabel.text = gameViewController?.names.second
    
    switch self.player {
    case .first:
      self.gameViewController?.firstPlayerTurnLabel.isHidden = false
      self.gameViewController?.secondPlayerTurnLabel.isHidden = true
    case .second:
      gameboard?.clear()
      gameboardView?.clear()
      self.gameViewController?.firstPlayerTurnLabel.isHidden = true
      self.gameViewController?.secondPlayerTurnLabel.isHidden = false
    }
  }
  
  public func addMark(at position: GameboardPosition) {
    Log(.playerInput(player: player, position: position))

    guard let gameboardView = self.gameboardView,
          gameboardView.canPlaceMarkView(at: position),
          let gameboard = gameboard
    else { return }
    
    let command = PlaceMarkCommand(
      player: player,
      position: position,
      gameboard: gameboard,
      gameboardView: gameboardView,
      forcePlaceMark: true)
    
    _ = gameViewController?.commands.addComand(command)
 
    gameboardView.placeMarkView(markViewPrototype.copy(), at: position)
    
    let count = gameViewController?.commands.count(for: player)
    isCompleted = count == Constants.movesCount
    isDetermineWinner = isCompleted && player == .second
    
    if isDetermineWinner {
      gameboardView.clear()
      gameViewController?.commands.execute()
    }
  }
}

extension PlayerInputFiveState {
  enum Constants {
    static let movesCount = 5
  }
}
