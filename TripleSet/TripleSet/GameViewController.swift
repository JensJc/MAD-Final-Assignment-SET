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
    
    let game: Game = Game()
    let cardDeck: CardDeck = CardDeck()
    
    var cardDeckOnTable = [Card?]()
    var selectedCardIndexes = [IndexPath]()
    
    var foundSets: Int = 0
    
    var soundEffectSettingOn = false
    var musicSettingOn = false
    
    private struct Sounds {
        static let CardClick = "cardclick"
        static let SetFound = "setfound"
        static let WrongSet = "wrongset"
    }
    
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
        // Do any additional setup after loading the view.
        
        soundEffectSettingOn = UserDefaults.sharedInstance.soundEffects
        musicSettingOn = UserDefaults.sharedInstance.music
        
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if musicSettingOn { playBackgroundMusic() }
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
    
    func playCardClickSound() {
        playSound(soundDescription: Sounds.CardClick)
    }
    
    func playSetFoundSound() {
        playSound(soundDescription: Sounds.SetFound)
    }
    
    func playWrongSetSound() {
        playSound(soundDescription: Sounds.WrongSet)
    }
    
    func playSound(soundDescription: String) {
        let url = Bundle.main.url(forResource: soundDescription, withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
            buttonSoundPlayer = player
            
            buttonSoundPlayer?.prepareToPlay()
            buttonSoundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GameCollectionViewCell
        
        if let card = cardDeckOnTable[indexPath.item] {
            cell.setCard(card: card)
        }
        else {
            cell.setEmpty()
        }
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if soundEffectSettingOn { playCardClickSound() }

        let selectedCell:GameCollectionViewCell = collectionView.cellForItem(at: indexPath)! as! GameCollectionViewCell
        if let card = cardDeckOnTable[indexPath.item] {
            selectedCell.selectCard(card: card)
            
            if let currentSelectedCardIndex = selectedCardIndexes.index(where: {$0 == indexPath}) {
                selectedCardIndexes.remove(at: currentSelectedCardIndex)
            }
            else {
                selectedCardIndexes.append(indexPath)
            }
            
            tryToCheckForSet(collectionView)

            print("You selected card \(card.getDescription())")
        }
        
        print("You selected cell #\(indexPath.item)!")
    }
    
    func startGame() {
        
        cardDeck.generateCardDeck()
        cardDeckOnTable = cardDeck.getCardDeckOnTable()

        game.setTests()
        refreshInfo()
    }
    
    func tryToCheckForSet(_ collectionView: UICollectionView) {
        if selectedCardIndexes.count == 3 {

            let setFound = checkForSet()
            print("setFound: \(setFound)")
            
            if setFound {
                // replace Cards
                if soundEffectSettingOn { playSetFoundSound() }
                replaceCards(for: collectionView)
                collectionView.reloadData()
                foundSets += 1
                refreshInfo()
                
                if game.isGameOver(cardDeck: cardDeck) {
                    print(">>> GAME OVER!! <<<")
                }
            }
            else {
                // deselect items
                if soundEffectSettingOn { playWrongSetSound() }
                deselectCurrentCells(for: collectionView)
            }
        }
    }
    
    func checkForSet() -> Bool {
        let card1 = cardDeckOnTable[selectedCardIndexes[0].item]
        let card2 = cardDeckOnTable[selectedCardIndexes[1].item]
        let card3 = cardDeckOnTable[selectedCardIndexes[2].item]
        
        return game.checkSet(card1: card1!, card2: card2!, card3: card3!)
    }
    
    func deselectCurrentCells(for collectionView: UICollectionView) {
        for indexpath in selectedCardIndexes {
            let selectedCell:GameCollectionViewCell = collectionView.cellForItem(at: indexpath)! as! GameCollectionViewCell
            if let card = cardDeckOnTable[indexpath.item] {
                selectedCell.selectCard(card: card)
            }
        }
        selectedCardIndexes.removeAll()
    }
    
    func replaceCards(for collectionView: UICollectionView) {
        let card1 = cardDeckOnTable[selectedCardIndexes[0].item]
        let card2 = cardDeckOnTable[selectedCardIndexes[1].item]
        let card3 = cardDeckOnTable[selectedCardIndexes[2].item]
        
        deselectCurrentCells(for: collectionView)
        
        cardDeck.replaceCardOnTable(cardToReplace: card1!)
        cardDeck.replaceCardOnTable(cardToReplace: card2!)
        cardDeck.replaceCardOnTable(cardToReplace: card3!)
        
        cardDeckOnTable = cardDeck.getCardDeckOnTable()
    }
    
    func refreshInfo() {
        print("Possibilities to make a set: \(game.getPossibilitiesToMakeSet(cardDeck: cardDeckOnTable))")
        print("Cards in deck: \(cardDeck.getCardDeckRemainingCount())")
        print("Found sets: \(foundSets)")
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
