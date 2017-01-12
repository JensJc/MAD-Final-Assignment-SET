//
//  CardDeck.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 12-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import Foundation
import GameplayKit

class CardDeck {
    
    private struct Amount {
        static let One = 1
        static let Two = 2
        static let Three = 3
    }
    
    private struct Figure {
        static let Cloud = "cl"
        static let Star = "st"
        static let Circle = "ci"
    }
    
    private struct Color {
        static let Red = UIColor.red
        static let Green = UIColor.green
        static let Blue = UIColor.blue
    }
    
    private struct Filling {
        static let Line = "l"
        static let Stripes = "s"
        static let Full = "f"
    }
    
    var amounts = [Amount.One, Amount.Two, Amount.Three]
    var figures = [Figure.Cloud, Figure.Star, Figure.Circle]
    var colors = [Color.Red, Color.Green, Color.Blue]
    var fillings = [Filling.Line, Filling.Stripes, Filling.Full]
    
    private var cardDeckAll = [Card]()
    
    private var cardDeckRemaining = [Card]()
    private var cardDeckOnTable = [[Card]]()
 
    func generateCardDeck() {
        
        var combinations = 0
        for i in 0 ..< amounts.count  {
            for j in 0 ..< figures.count {
                for k in 0 ..< colors.count {
                    for l in 0 ..< fillings.count {
                        let amount = amounts[i]
                        let figure = figures[j]
                        let color = colors[k]
                        let filling = fillings[l]
                        cardDeckAll.append(Card(amount: amount, figure: figure, color: color, filling: filling))
                        combinations += 1
                    }
                }
            }
        }
        
        print(combinations)
        
//        printDeck(cardDeckToPrint: alleKaarten)
        
        print("time to shuffle")
        
        let shuffledCards = shuffleCards(cardDeck: cardDeckAll)
        
        printDeck(cardDeckToPrint: shuffledCards)
        
        print("shuffled items: " + shuffledCards.count.description)
    }
    
    func shuffleCards(cardDeck: [Card]) -> [Card] {
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardDeck) as! [Card]
    }
    
    func shuffleCards(cardDeckRemaining: [Card], cardDeckOnTable: [[Card]]) -> [Card] {
        
        var allRemainingCards = [Card]()
        allRemainingCards.append(contentsOf: cardDeckRemaining)
        
        for row in cardDeckOnTable {
            for card in row {
                allRemainingCards.append(card)
            }
        }
        
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allRemainingCards) as! [Card]
    }
    
    func calculateMaxCombinations(baseNumber base: Int, exponent: Int) -> Int {
        return Int(pow(Double(base),Double(exponent)))
    }
    
    // print functions
    func printDeck(cardDeckToPrint: [Card]) {
        for card in cardDeckToPrint {
            print(card.getDescription())
        }
    }
    
}
