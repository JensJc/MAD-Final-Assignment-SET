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
    
    private static let amountCardsOnTable = 16
    
    private var cardDeckAllShuffled = [Card]()
    
    private var cardDeckRemaining = [Card]()
    private var cardDeckOnTable = [Card?]()
 
    func generateCardDeck() {
        
        var allCards = [Card]()
        var combinations = 0
        
        for i in 0 ..< amounts.count  {
            for j in 0 ..< figures.count {
                for k in 0 ..< colors.count {
                    for l in 0 ..< fillings.count {
                        let amount = amounts[i]
                        let figure = figures[j]
                        let color = colors[k]
                        let filling = fillings[l]
                        allCards.append(Card(amount: amount, figure: figure, color: color, filling: filling))
                        combinations += 1
                    }
                }
            }
        }
        
        print(combinations)
        print("time to shuffle")
        
        cardDeckAllShuffled = shuffleCards(cardDeck: allCards)
        
        printDeck(cardDeckToPrint: cardDeckAllShuffled, allCardDescriptions: true)
        print("shuffled cards: " + cardDeckAllShuffled.count.description)
        
        devideCardStacks(cardsToDevide: cardDeckAllShuffled)
        
        print("cardDeckOnTable")
        printDeck(cardDeckToPrint: cardDeckOnTable, allCardDescriptions: true)
        print("cardDeckRemaining")
        printDeck(cardDeckToPrint: cardDeckRemaining, allCardDescriptions: true)
    }
    
    func getCardDeckOnTable() -> [Card?] {
        return cardDeckOnTable
    }
    
    func getCardDeckRemaining() -> [Card] {
        return cardDeckRemaining
    }
    
    func getCardDeckAll() -> [Card] {
        return cardDeckAllShuffled
    }
    
    func shuffleCards(cardDeck: [Card]) -> [Card] {
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cardDeck) as! [Card]
    }
    
    func shuffleCards(cardDeckRemaining: [Card], cardDeckOnTable: [Card]) -> [Card] {
        
        var allRemainingCards = [Card]()
        allRemainingCards.append(contentsOf: cardDeckRemaining)
        allRemainingCards.append(contentsOf: cardDeckOnTable)
        
        return GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allRemainingCards) as! [Card]
    }
    
    func devideCardStacks(cardsToDevide: [Card]) {
        var count = 0
        for card in cardsToDevide {
            if count < CardDeck.amountCardsOnTable {
                cardDeckOnTable.append(card)
                
                // Test for one nil card on position 6:
//                if count != 5 {cardDeckOnTable.append(card)}
//                else {cardDeckOnTable.append(nil)}
            }
            else {
                cardDeckRemaining.append(card)
            }
            count += 1
        }
    }
    
    func replaceCardOnTable(cardToReplace: Card) {
        if let indexOfCardToReplace = cardDeckOnTable.index(where: {$0 === cardToReplace}) {
            cardDeckOnTable[indexOfCardToReplace] = getNewCardFromRemainingCards()
        }
    }
    
    func getNewCardFromRemainingCards() -> Card? {
        if !cardDeckRemaining.isEmpty {
            return cardDeckRemaining.popLast()
        }
        else {
            return nil
        }
    }
    
    func selectCard(card: Card) -> Bool {
        return card.select()
    }
    
    func checkIfSetIsSelected() -> Bool {
        var selectedCardsCount = 0
        for card in cardDeckOnTable {
            if (card?.IsSelected()) != nil {
                selectedCardsCount += 1
            }
        }
        
        if selectedCardsCount == 3 { return true }
        else { return false }
    }
    
    // MARK: - Helper functions
    
    func calculateMaxCombinations(baseNumber base: Int, exponent: Int) -> Int {
        return Int(pow(Double(base),Double(exponent)))
    }
    
    // print functions
    func printDeck(cardDeckToPrint: [Card?], allCardDescriptions: Bool) {
        if allCardDescriptions {
            for card in cardDeckToPrint {
                print(card?.getDescription() ?? "nil >> no card here!")
            }
        }
        print("total cards: " + cardDeckToPrint.count.description)
    }
    
}
