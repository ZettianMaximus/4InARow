//
//  ButtonModel.swift
//  4InARow
//
//  Created by Jacobo Garza on 4/7/22.
//

import Foundation
import SwiftUI

class ButtonModel: ObservableObject {
    @Published var pieces = [Piece]()
    @Published var activeSymbol: Symbol? = .red
    @Published var winner: Symbol?
    
    @Published var toggleAIvar : Bool = true
    @Published var redTurn : Bool = true
    @Published var redScore : Int = 0
    @Published var yellowScore : Int = 0

    func addPiece(in column: Int) {
        let currentPiecesInColumn = pieces.filter { $0.location.column == column }
        var row = 0

        if let highestRow = currentPiecesInColumn.max(by: { $0.location.row < $1.location.row }) {
            row = highestRow.location.row + 1
        }

        let location = Location(row: row, column: column)
        let piece = Piece(symbol: activeSymbol ?? .red, location: location)

        withAnimation(.spring()) { //needs import SwiftUI
            pieces.append(piece)
        }
    }

    func checkEnd() -> Symbol? {
        let redPieces = pieces.filter { $0.symbol == .red }
        let yellowPieces = pieces.filter { $0.symbol == .yellow }

        if check4InRow(with: redPieces) {
            redScore += 1 // add to score
            return .red
        }

        if check4InRow(with: yellowPieces) {
            yellowScore += 1 // add to score
            return .yellow
        }

        if pieces.count >= 42 {
            return .tie
        }
        return nil
    }

    func check4InRow(with pieces: [Piece]) -> Bool {
        guard pieces.count >= 4 else { return false }
        let locations = pieces.map { $0.location }

        /// check vertical columns
        for column in 0 ..< 7 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column)
                let location2 = Location(row: row + 2, column: column)
                let location3 = Location(row: row + 3, column: column)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check horizontal rows
        for row in 0 ..< 6 {
            for column in 0 ..< 7 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row, column: column + 1)
                let location2 = Location(row: row, column: column + 2)
                let location3 = Location(row: row, column: column + 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check ascending stairs
        for column in 0 ..< 4 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column + 1)
                let location2 = Location(row: row + 2, column: column + 2)
                let location3 = Location(row: row + 3, column: column + 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        /// check descending stairs
        for column in 3 ..< 7 {
            for row in 0 ..< 3 {
                let location0 = Location(row: row, column: column)
                let location1 = Location(row: row + 1, column: column - 1)
                let location2 = Location(row: row + 2, column: column - 2)
                let location3 = Location(row: row + 3, column: column - 3)

                if
                    locations.contains(location0),
                    locations.contains(location1),
                    locations.contains(location2),
                    locations.contains(location3)
                {
                    return true
                }
            }
        }

        return false
    }
}

enum Symbol: Equatable { // determining if red circle or yellow
    case red
    case yellow
    case tie
}

struct Location: Equatable {
    var row = 0
    var column = 0
}

struct Piece: Equatable {
    var symbol: Symbol
    var location: Location // section = row, item = column
}


