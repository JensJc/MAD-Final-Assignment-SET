//
//  Card.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    private var amount: Int = 0
    private var figure: String = ""
    private var color: UIColor = UIColor.black
    private var filling: String = ""
    private var selected: Bool = false
    
    init(amount: Int, figure: String, color: UIColor, filling: String) {
        self.amount = amount
        self.figure = figure
        self.color = color
        self.filling = filling
    }
    
    func getAmount() -> Int {
        return amount
    }
    
    func getFigure() -> String {
        return figure
    }
    
    func getColor() -> UIColor {
        return color
    }
    
    func getFilling() -> String {
        return filling
    }
    
    func IsSelected() -> Bool {
        return selected
    }
    
    func getDescription() -> String {
        return "\(amount)" + "\(figure)" + color.getText() + "\(filling)"
    }
    
    func select() -> Bool {
        if selected {
            selected = false
        }
        else {
            selected = true
        }
        
        return selected
    }
    
}

extension UIColor {
    func getText() -> String {
        switch self {
        case UIColor.red:
            return "r"
        case UIColor.green:
            return "g"
        case UIColor.blue:
            return "b"
        default:
            return "x"
        }
    }
}
