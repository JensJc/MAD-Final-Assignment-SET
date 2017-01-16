//
//  GameCollectionViewCell.swift
//  TripleSet
//
//  Created by developer on 12/01/2017.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    
    private struct Constants {
        static let radius = CGFloat(4)
    }
    
    private struct BackgroundColor {
        static let Deselected = UIColor.white
        static let Selected = UIColor.yellow
        static let Empty = UIColor.gray
    }
    
    func setCard(card: Card) {
        self.backgroundColor = BackgroundColor.Deselected
        self.layer.cornerRadius = Constants.radius
        
        let amount = card.getAmount()
        let shape = card.getFigure()
        let color = card.getColor()
        let filling = card.getFilling()
        
        var image = UIImage(named: "\(shape)\(filling)")
        
        image = image?.withRenderingMode(.alwaysTemplate)
        
        clearAll()
        
        switch amount{
        case 1:
            imageTwo.image = image
            
            imageTwo.tintColor = color
        case 2:
            imageOne.image = image
            imageThree.image = image
            
            imageOne.tintColor = color
            imageThree.tintColor = color
        case 3:
            imageOne.image = image
            imageTwo.image = image
            imageThree.image = image
            
            imageOne.tintColor = color
            imageTwo.tintColor = color
            imageThree.tintColor = color
        default: break
            
        }
        
    }
    
    func clearAll() {
        imageOne.image = nil
        imageOne.tintColor = UIColor.clear
        imageTwo.image = nil
        imageTwo.tintColor = UIColor.clear
        imageThree.image = nil
        imageThree.tintColor = UIColor.clear
    }
    
    func selectCard(card: Card) {
        if card.select() {
            UIView.animate(withDuration: 2, animations: { self.backgroundColor = BackgroundColor.Selected })
        }
        else {
            UIView.animate(withDuration: 1, animations: { self.backgroundColor = BackgroundColor.Deselected })
        }
        self.layer.cornerRadius = Constants.radius
    }
    
    func setEmpty() {
        self.backgroundColor = BackgroundColor.Empty
        self.layer.cornerRadius = Constants.radius
        
        clearAll()
    }
}
