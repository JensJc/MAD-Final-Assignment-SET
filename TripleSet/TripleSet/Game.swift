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
        else if checkForAllDifferent(bool1: differentAmounts, bool2: differentFigures, bool3: differentColors, bool4: differentFillings){
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
