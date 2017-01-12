//
//  GameViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var backgroundMusicPlayer: AVAudioPlayer?
    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    var buttonSoundPlayer: AVAudioPlayer?
    
    @IBOutlet weak var cardView: UICollectionView! {
        didSet {
            if let image = UIImage(named: "normaltheme.png") {
                cardView.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "normaltheme.png") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
     
        startGame()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        playBackgroundMusic()
        
        startGame()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer?.stop()
        }
    }
    
    
    
    // MARK: - Funcs
    
    func playBackgroundMusic() {
        let url = Bundle.main.url(forResource: "gamemusic", withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
            backgroundMusicPlayer = player
            
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func cardClickSound() {
        let url = Bundle.main.url(forResource: "cardclick", withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
            buttonSoundPlayer = player
            
            buttonSoundPlayer?.prepareToPlay()
            buttonSoundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
        let cardDeck = CardDeck()
        cardDeck.generateCardDeck()
        
        let game = Game()
        game.setTests()
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GameCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.setCard(amount: 3, shape: "cl", filling: "s", color: UIColor.blue)
        cell.backgroundColor = UIColor.white // make cell more visible in our example project   
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        cardClickSound()
        
        
        print("You selected cell #\(indexPath.item)!")
    }
    
    func startGame() {
        
        let cardDeck = CardDeck()
        cardDeck.generateCardDeck()
        
        let game = Game()
        game.setTests()
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
