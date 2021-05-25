//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
  private let gameboard = Gameboard()
  private var currentState: GameState! {
    didSet { currentState.begin() }
  }
  private lazy var referee = Referee(gameboard: self.gameboard)
  var names = (
    first: Constants.Names.player1,
    second: Constants.Names.player2
  )
  let commands = CommandInvoker()
  
  @IBOutlet var gameboardView: GameboardView!
  @IBOutlet var firstPlayerTurnLabel: UILabel!
  @IBOutlet var secondPlayerTurnLabel: UILabel!
  @IBOutlet var winnerLabel: UILabel!
  @IBOutlet var restartButton: UIButton!
  @IBOutlet weak var gameModeControl: UISegmentedControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewDidLoadState()
  }
  
  @IBAction func restartButtonTapped(_ sender: UIButton) {
    Log(.restartGame)
    gameboard.clearAll()
    gameboardView.clear()
    goToFirstState()
  }
  @IBAction func gameModeValutChanged(_ sender: UISegmentedControl) {
    Log(.restartGame)
    switchMode()
    gameboard.clearAll()
    gameboardView.clear()
    goToFirstState()
  }
}

extension GameViewController {
  private func viewDidLoadState() {
    goToFirstState()
    gameboardView.onSelectPosition = { [weak self] position in
      guard let self = self else { return }
      
      self.currentState.addMark(at: position)
      if self.currentState.isCompleted {
        self.goToNextState()
      }
    }
  }
  
  private func goToFirstState() {
    let player = Player.first
    
    switch gameModeControl.selectedSegmentIndex {
    case Constants.Mode.playerVsPlayer:
      self.currentState = PlayerInputFiveState(
        player: player,
        markViewPrototype: player.markViewPrototype,
        gameViewController: self,
        gameboard: gameboard,
        gameboardView: gameboardView)
    case Constants.Mode.playerVsComputer:
      self.currentState = ComputerInputState(
        player: player,
        markViewPrototype: player.markViewPrototype,
        gameViewController: self,
        gameboard: gameboard,
        gameboardView: gameboardView)
    default:
      break
    }
  }
  
  private func goToNextState() {
    if currentState.isDetermineWinner,
       let winner = self.referee.determineWinner() {
      self.currentState = GameEndedState(winner: winner, gameViewController: self)
      return
    }
    
    if let playerInputState = currentState as? PlayerInputFiveState {
      let player = playerInputState.player.next
      self.currentState = PlayerInputFiveState(
        player: player,
        markViewPrototype: player.markViewPrototype,
        gameViewController: self,
        gameboard: gameboard,
        gameboardView: gameboardView)
    }
    if let computerInputState = currentState as? ComputerInputState {
      let player = computerInputState.player.next
      self.currentState = ComputerInputState(
        player: player,
        markViewPrototype: player.markViewPrototype,
        gameViewController: self,
        gameboard: gameboard,
        gameboardView: gameboardView)
    }
  }

  private func switchMode() {
    switch gameModeControl.selectedSegmentIndex {
    case Constants.Mode.playerVsPlayer:
      names.second = Constants.Names.player2
    case Constants.Mode.playerVsComputer:
      names.second = Constants.Names.playerComputer
    default:
      break
    }
  }
}

extension GameViewController {
  enum Constants {
    enum Mode {
      static let playerVsPlayer = 0
      static let playerVsComputer = 1
    }
    
    enum Names {
      static let player1 = "1st player"
      static let player2 = "2nd player"
      static let playerComputer = "Computer"
   }
  }
}

