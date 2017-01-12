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
    
    func setCard(amount: Int, shape: String, filling: String, color: UIColor) {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 4
        
        var image = UIImage(named: "\(shape)\(filling)")
        
        image = image?.withRenderingMode(.alwaysTemplate)
        
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
    
    
}
