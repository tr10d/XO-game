//
//  Gameboard.swift
//  XO-game
//
//  Created by Evgeny Kireev on 27/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public final class Gameboard {
  private lazy var positions = initialPositions()
  
  func clearAll() {
    clear()
  }
}

extension Gameboard {
  func setPlayer(_ player: Player, at position: GameboardPosition) {
    positions[position.column][position.row] = player
  }
  
  func clear() {
    positions = initialPositions()
  }
  
  func contains(player: Player, at positions: [GameboardPosition]) -> Bool {
    for position in positions {
      guard contains(player: player, at: position) else {
        return false
      }
    }
    return true
  }
  
  func contains(player: Player, at position: GameboardPosition) -> Bool {
    let (column, row) = (position.column, position.row)
    return positions[column][row] == player
  }
  
  func getFreePositions() -> [GameboardPosition] {
    var array = [GameboardPosition]()
    for row in 0 ..< GameboardSize.rows {
      for column in 0 ..< GameboardSize.columns {
        if positions[column][row] == nil {
          array.append(GameboardPosition(column: column, row: row))
        }
      }
    }
    return array
  }

  func getPositions() -> [GameboardPosition: Player?] {
    var array = [GameboardPosition: Player?]()
    for row in 0 ..< GameboardSize.rows {
      for column in 0 ..< GameboardSize.columns {
        array[GameboardPosition(column: column, row: row)] = positions[column][row]
      }
    }
    return array
  }
}

extension Gameboard {
  private func initialPositions() -> [[Player?]] {
    var positions: [[Player?]] = []
    for _ in 0 ..< GameboardSize.columns {
      let rows = Array<Player?>(repeating: nil, count: GameboardSize.rows)
      positions.append(rows)
    }
    return positions
  }
}

extension Gameboard: CustomStringConvertible {
  public var description: String {
    var string = ""
    for row in 0 ..< GameboardSize.rows {
      for column in 0 ..< GameboardSize.columns {
        string += "\(positions[column][row]?.description ?? "") "
      }
      string += "\n"
    }
    return string
  }
}
