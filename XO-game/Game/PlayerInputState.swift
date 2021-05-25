//
//  PlayerInputState.swift
//  XO-game
//
//  Created by  Sergei on 21.05.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final public class PlayerInputState: GameState {
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
      self.gameViewController?.firstPlayerTurnLabel.isHidden = true
      self.gameViewController?.secondPlayerTurnLabel.isHidden = false
    }
  }
  
  public func addMark(at position: GameboardPosition) {
    Log(.playerInput(player: player, position: position))

    guard let gameboardView = self.gameboardView
          , gameboardView.canPlaceMarkView(at: position)
    else { return }
    
    self.gameboard?.setPlayer(self.player, at: position)
    self.gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)
    self.isCompleted = true
  }
}
