//
//  Game.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 12-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import Foundation
import UIKit

class Game {
    
    struct Score {
        static let setFound = 500
        static let hintUsed = -250
    }
    
    let cardDeck: CardDeck = CardDeck()
    var score: Int = 0
    var startTime: NSDate?
    
    //MARK: - Game functions
    
    func start() {
        cardDeck.generateCardDeck()
        startTime = NSDate()
    }
    
    func isGameOver() -> Bool {
        let openCards = cardDeck.getCardDeckOnTable()
        if cardDeck.getCardDeckRemainingCount() == 0 && getPossibilitiesToMakeSet(cardDeck: openCards) == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func replaceCardOnTable(card: Card) -> Card?{
        return cardDeck.replaceCardOnTable(cardToReplace: card)
    }
    
    func getRemaingCardDeckCount() -> Int {
        return cardDeck.getCardDeckRemainingCount()
    }
    
    func shuffleCards() -> [Card?] {
        cardDeck.shuffleAllCards()
        return cardDeck.getCardDeckOnTable()
    }
    
    func getCardsOnTable() -> [Card?] {
        return cardDeck.getCardDeckOnTable()
    }
    
    func scoreSetFound() {
        score += Score.setFound
    }
    
    func scoreHintUsed() {
        score += Score.hintUsed
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getElapsedTime() -> Double {
        let endTime = NSDate()
        return endTime.timeIntervalSince(startTime! as Date)
    }
    
    // MARK: - Checking for SET
    
    func checkSet(card1: Card, card2: Card, card3: Card) -> Bool {
        let sameAmounts = checkForSameAmount(card1: card1, card2: card2, card3: card3)
        let sameFigures = checkForSameFigure(card1: card1, card2: card2, card3: card3)
        let sameColors = checkForSameColor(card1: card1, card2: card2, card3: card3)
        let sameFillings = checkForSameFilling(card1: card1, card2: card2, card3: card3)

        if !checkForPossibleSet(amounts: sameAmounts, figures: sameFigures, colors: sameColors, fillings: sameFillings) {
            return false
        }
        
        let differentAmounts = checkForAllDifferentAmounts(card1: card1, card2: card2, card3: card3)
        let differentFigures = checkForAllDifferentFigures(card1: card1, card2: card2, card3: card3)
        let differentColors = checkForAllDifferentColors(card1: card1, card2: card2, card3: card3)
        let differentFillings = checkForAllDifferentFillings(card1: card1, card2: card2, card3: card3)
        
        if sameAmounts && checkForDifference(bool1: differentFigures, bool2: differentColors, bool3: differentFillings) {
            return true
        }
        else if sameFigures && checkForDifference(bool1: differentAmounts, bool2: differentColors, bool3: differentFillings) {
            return true
        }
        else if sameColors && checkForDifference(bool1: differentAmounts, bool2: differentFigures, bool3: differentFillings) {
            return true
        }
        else if sameFillings && checkForDifference(bool1: differentAmounts, bool2: differentFigures, bool3: differentColors) {
            return true
        }
        else if sameAmounts && sameFigures && checkForDifference(bool1: differentColors, bool2: differentFillings, bool3: true) {
            return true
        }
        else if sameAmounts && sameColors && checkForDifference(bool1: differentFigures, bool2: differentFillings, bool3: true) {
            return true
        }
        else if sameAmounts && sameFillings && checkForDifference(bool1: differentColors, bool2: differentFigures, bool3: true) {
            return true
        }
        else if sameFigures && sameColors && checkForDifference(bool1: differentAmounts, bool2: differentFillings, bool3: true) {
            return true
        }
        else if sameFigures && sameFillings && checkForDifference(bool1: differentAmounts, bool2: differentColors, bool3: true) {
            return true
        }            
        else if sameColors && sameFillings && checkForDifference(bool1: differentAmounts, bool2: differentFigures, bool3: true) {
            return true
        }
        else if sameAmounts && sameFigures && sameColors && checkForDifference(bool1: differentFillings, bool2: true, bool3: true) {
            return true
        }
        else if sameAmounts && sameFigures && sameFillings && checkForDifference(bool1: differentColors, bool2: true, bool3: true) {
            return true
        }
        else if sameAmounts && sameFillings && sameColors && checkForDifference(bool1: differentFigures, bool2: true, bool3: true) {
            return true
        }
        else if sameFigures && sameFillings && sameColors && checkForDifference(bool1: differentAmounts, bool2: true, bool3: true) {
            return true
        }
        else if checkForAllDifferent(bool1: differentAmounts, bool2: differentFigures, bool3: differentColors, bool4: differentFillings) {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForDifference(bool1: Bool, bool2: Bool, bool3: Bool) -> Bool {
        var toCheck = Set<Bool>()
        toCheck.insert(bool1)
        toCheck.insert(bool2)
        toCheck.insert(bool3)
        
        var numberOfTrues = 0
        for value in toCheck {
            if value {
                numberOfTrues += 1
            }
        }
        
        if numberOfTrues == toCheck.count
        {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForAllDifferent(bool1: Bool, bool2: Bool, bool3: Bool, bool4: Bool) -> Bool {
        var toCheck = Set<Bool>()
        toCheck.insert(bool1)
        toCheck.insert(bool2)
        toCheck.insert(bool3)
        toCheck.insert(bool4)
        
        var numberOfTrues = 0
        for value in toCheck {
            if value {
                numberOfTrues += 1
            }
        }
        
        if numberOfTrues == toCheck.count
        {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForPossibleSet(amounts: Bool, figures: Bool, colors: Bool, fillings: Bool) -> Bool {
        var toCheck = Set<Bool>()
        toCheck.insert(amounts)
        toCheck.insert(figures)
        toCheck.insert(colors)
        toCheck.insert(fillings)
        
        var numberOfTrues = 0
        for value in toCheck {
            if value {
                numberOfTrues += 1
            }
        }

        if numberOfTrues <= 1 {
            return true
        }
        else {
            return false
        }
        
    }
    
    func checkForSameAmount(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getAmount() == card2.getAmount() && card2.getAmount() == card3.getAmount() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForAllDifferentAmounts(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getAmount() != card2.getAmount() && card2.getAmount() != card3.getAmount() && card1.getAmount() != card3.getAmount() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForSameFigure(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getFigure() == card2.getFigure() && card2.getFigure() == card3.getFigure() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForAllDifferentFigures(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getFigure() != card2.getFigure() && card2.getFigure() != card3.getFigure() && card1.getFigure() != card3.getFigure() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForSameColor(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getColor() == card2.getColor() && card2.getColor() == card3.getColor() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForAllDifferentColors(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getColor() != card2.getColor() && card2.getColor() != card3.getColor() && card1.getColor() != card3.getColor() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForSameFilling(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getFilling() == card2.getFilling() && card2.getFilling() == card3.getFilling() {
            return true
        }
        else {
            return false
        }
    }
    
    func checkForAllDifferentFillings(card1: Card, card2: Card, card3: Card) -> Bool {
        if card1.getFilling() != card2.getFilling() && card2.getFilling() != card3.getFilling() && card1.getFilling() != card3.getFilling() {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Calculation of possible SETS
    
    func getPossibilitiesToMakeSet(cardDeck: [Card?]) -> Int {
        var possibleSetsFound = 0
        
        for i in 0 ..< cardDeck.count-2  {
            for j in 0 ..< cardDeck.count-1 {
                for k in 0 ..< cardDeck.count {
                    let card1 = cardDeck[i]
                    let card2 = cardDeck[j]
                    let card3 = cardDeck[k]
                    
                    if !hasEmptyCards(card1: card1, card2: card2, card3: card3) {
                        if checkSet(card1: card1!, card2: card2!, card3: card3!) {
                            if possibleSetsFound < 3 {
                                possibleCombination[0] = card1!
                                possibleCombination[1] = card2!
                                possibleCombination[2] = card3!
                            }
                            possibleSetsFound += 1
                        }
                    }
                }
            }
        }
        
        if possibleSetsFound == 0 {
            possibleCombination[0] = nil
            possibleCombination[1] = nil
            possibleCombination[2] = nil
        }
        
//        print("Possibilities to make a set: \(possibleSetsFound)")
        print("Possible combination: \(possibleCombination[0]?.getDescription()) - \(possibleCombination[1]?.getDescription()) - \(possibleCombination[2]?.getDescription())")
        
        return possibleSetsFound / 3
    }
    
    var possibleCombination: [Card?] = [
        nil,
        nil,
        nil
    ]
    
    var possibleCombinationIndexes: [Int] = [
        99,
        99,
        99
    ]
    
    func hasEmptyCards(card1: Card?, card2: Card?, card3: Card?) -> Bool {
        if card1 == nil || card2 == nil || card3 == nil {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Test
    
    func setTests() {
        var card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        var card2 = Card(amount: 2, figure: "st", color: UIColor.green, filling: "s")
        var card3 = Card(amount: 3, figure: "ci", color: UIColor.blue, filling: "f")
        print("try1 all others >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
        
        card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        card2 = Card(amount: 1, figure: "st", color: UIColor.green, filling: "s")
        card3 = Card(amount: 1, figure: "ci", color: UIColor.blue, filling: "f")
        print("try2 same amount >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
        
        card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        card2 = Card(amount: 2, figure: "cl", color: UIColor.green, filling: "s")
        card3 = Card(amount: 3, figure: "cl", color: UIColor.blue, filling: "f")
        print("try3 same figures >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
        
        card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        card2 = Card(amount: 2, figure: "st", color: UIColor.red, filling: "s")
        card3 = Card(amount: 3, figure: "ci", color: UIColor.red, filling: "f")
        print("try4 same colors >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
        
        card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        card2 = Card(amount: 2, figure: "st", color: UIColor.green, filling: "l")
        card3 = Card(amount: 3, figure: "ci", color: UIColor.blue, filling: "l")
        print("try5 same fillings >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
        
        card1 = Card(amount: 1, figure: "cl", color: UIColor.red, filling: "l")
        card2 = Card(amount: 2, figure: "cl", color: UIColor.green, filling: "s")
        card3 = Card(amount: 3, figure: "cl", color: UIColor.red, filling: "f")
        print("try6 same figures, same colors >> found set: " + "\(checkSet(card1: card1, card2: card2, card3: card3))")
    }
}
