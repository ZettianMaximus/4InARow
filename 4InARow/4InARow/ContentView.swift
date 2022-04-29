//
//  ContentView.swift
//  4InARow
//
//  Created by Jacobo Garza on 4/1/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ButtonModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("4 In A Row!")
                    .font(.system(size: 48))
                .padding(25)
                VStack {
                    Text("Red Score: \(self.model.redScore)")
                        .font(.system(size: 36))
                    Text("Yellow Score: \(self.model.yellowScore)")
                        .font(.system(size: 36))
                }
                Button { // toggles AI and resets game
                    if model.toggleAIvar == true {
                        model.toggleAIvar = false
                    } else if model.toggleAIvar == false {
                        model.toggleAIvar = true
                    }
                    model.pieces.removeAll()
                    model.activeSymbol = .red
                    model.winner = nil
                    model.redTurn = true
                } label: {
                    Text("Toggle AI")
                        .font(.system(size: 36))
                }
            }
            
            if let winner = model.winner { //displays when winner is found
                HStack(spacing: 20) {
                    switch winner {
                    case .red:
                        Text("RED won!")
                            .foregroundColor(.red)
                    case .yellow:
                        Text("YELLOW won!")
                            .foregroundColor(.yellow)
                    default:
                        Text("TIE")
                            .foregroundColor(.blue)
                    }

                    Button { // play again button
//                        withAnimation(.spring()) {
//                            model.pieces.removeAll()
//                            model.activeSymbol = .red
//                            model.winner = nil
//                            model.redTurn = true
//                        }
                        model.pieces.removeAll()
                        model.activeSymbol = .red
                        model.winner = nil
                        model.redTurn = true
                    } label: {
                        Text("Play Again?")
                    }
                }
                .font(.system(size: 36, weight: .semibold))
            } else if let activeSymbol = model.activeSymbol {
                HStack(spacing: 20) {
                    switch activeSymbol {
                    case .red:
                        Text("RED's turn!")
                            .foregroundColor(.red)
                        
                    case .yellow:
                        Text("YELLOW's turn!")
                            .foregroundColor(.yellow)
                        
                    default:
                        EmptyView()
                    }
                }
                .font(.system(size: 36, weight: .semibold))
            }
            
            
            
            HStack {
                ForEach(0..<7, id: \.self) { column in
                    
                    var pieceCount = 0 // keeps track of how many pieces in columns

                    Button {
                        if model.toggleAIvar == false {
                            addPieceAndCheckSymbol(in: column)
                            pieceCount += 1
                        } else if model.toggleAIvar == true && model.redTurn == true {
                            addPieceAndCheckSymbol(in: column)
                            pieceCount += 1
                        } else if model.toggleAIvar == true && model.redTurn == false {
                            moveAI(in: column, pieceCount: pieceCount)
                            pieceCount += 1
//                            var column = Int.random(in: 0...6)
//                            if pieceCount <= 6 {
//                                addPieceAndCheckSymbol(in: column)
//                            }
                        }
//                        model.addPiece(in: column)
//                        if let activeSymbol = model.activeSymbol {
//                            switch activeSymbol {
//                            case .red:
//                                model.activeSymbol = .yellow
//                            case .yellow:
//                                model.activeSymbol = .red
//                            case .tie:
//                                model.activeSymbol = .red
//                            }
//                        }
//
//                        model.winner = model.checkEnd()

                    } label: {
                        VStack(spacing: 10) {

                            VStack {
                                if let winner = model.winner {
                                    switch winner {
                                    case .red:
                                        Color.red
                                    case .yellow:
                                        Color.yellow
                                    case .tie:
                                        Color.blue
                                    }
                                } else {
                                    Color.blue // the blue buttons on the top
                                }
                            }
                            .frame(height: 50)

                            ForEach(Array(0..<6).reversed(), id: \.self) { row in
                                let location = Location(row: row, column: column)
                                let piece = model.pieces.first(where: { $0.location == location })

                                SquareTile(location: location, symbol: piece?.symbol)
                            }
                        }
                    }
                    .disabled(disabledColumn(column: column)) // disable if full
                }
            }
            .disabled(model.winner != nil) // disable if winner
        }
    }
    
    func moveAI(in column: Int, pieceCount: Int) // currently doesnt keep track of row??
    {
        var column = Int.random(in: 0...6)
        if pieceCount >= 6 {
            print("There's already a piece there!")
            moveAI(in: column, pieceCount: pieceCount)
        } else {
            addPieceAndCheckSymbol(in: column)
        }
    }
    
    func addPieceAndCheckSymbol(in column: Int)
    {
        if model.redTurn == true {
            model.redTurn = false
        } else if model.redTurn == false {
            model.redTurn = true
        }
        model.addPiece(in: column)
        if let activeSymbol = model.activeSymbol {
            switch activeSymbol {
            case .red:
                model.activeSymbol = .yellow
            case .yellow:
                model.activeSymbol = .red
            case .tie:
                model.activeSymbol = .red
            }
        }

        model.winner = model.checkEnd()
    }
    
    // disable column if already full
    func disabledColumn(column: Int) -> Bool {
        let columnPieces = model.pieces.filter { $0.location.column == column }
        return columnPieces.count >= 6
    }
}

struct SquareTile: View { // this struct is the square tiles
    var location: Location
    var symbol: Symbol?
    var body: some View {
        Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0.2)
            .aspectRatio(contentMode: .fit) // important for looking like squares
            .overlay {
                VStack {
                    if let symbol = symbol {
                        switch symbol {
                        case .red:
                            CircleTile(color: .red)
                        case .yellow:
                            CircleTile(color: .yellow)
                        case .tie:
                            EmptyView()
                        }
                    }
                }
                .padding(16)
            }
    }
}

struct CircleTile: View { // this struct is the circle tiles that fill the squares
    let color: Color
    var body: some View {
        Circle()
            .fill(color)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait) // specifically for the orientation of the mobile device
    }
}
