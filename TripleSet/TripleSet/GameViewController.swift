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
    
    var score: Int = 0
    var foundSets: Int = 0
    var possibleSets: Int = 0
    var cardsInDeck: Int = 0
    
    var soundEffectSettingOn = false
    var musicSettingOn = false
    
    private struct Sounds {
        static let CardClick = "cardclick"
        static let SetFound = "setfound"
        static let WrongSet = "wrongset"
    }
    
    private struct LabelConstants {
        static let score = "Score:"
        static let foundSets = "Found sets:"
        static let possibleSets = "Possible Sets:"
        static let cardsInDeck = "Cards in deck:"
        
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet { scoreLabel.text = LabelConstants.score }
    }
    @IBOutlet weak var foundSetsLabel: UILabel! {
        didSet { foundSetsLabel.text = LabelConstants.foundSets }
    }
    @IBOutlet weak var possibleSetsLabel: UILabel! {
        didSet { possibleSetsLabel.text = LabelConstants.possibleSets }
    }
    @IBOutlet weak var cardsInDeckLabel: UILabel! {
        didSet { cardsInDeckLabel.text = LabelConstants.cardsInDeck }
    }
    
    @IBOutlet weak var cardView: UICollectionView! {
        didSet {
            if let image = UIImage(named: "normaltheme.png") {
                cardView.backgroundColor = UIColor(patternImage: image)
            }
        }
    }
    
    @IBAction func shakeButtonClicked(_ sender: UIButton) {
        deselectAllSelectedCells()
        
        cardDeck.shuffleAllCards()
        cardDeckOnTable = cardDeck.getCardDeckOnTable()
        cardView.reloadData()
        
        refreshInfo()
    }
    
    @IBAction func hintButtonClicked(_ sender: UIButton) {
        deselectAllSelectedCells()
        
        let possibleSet = game.possibleCombination
        
        var possibleSetIndexes = [Int]()
        for i in 0 ..< possibleSet.count {
            if let card = possibleSet[i] {
                possibleSetIndexes.append(cardDeckOnTable.index(where: {$0 === card})!)
            }
        }
        
        if possibleSetIndexes.count == 3 {
            selectCardByIndex(index: possibleSetIndexes[0])
            selectCardByIndex(index: possibleSetIndexes[1])
        }
        
        game.scoreHintUsed()
        refreshScore()
    }
    
    func selectCardByIndex(index: Int) {
        var indexPath = IndexPath(item: index, section: 0)
        let cellToSelect:GameCollectionViewCell = cardView.cellForItem(at: indexPath)! as! GameCollectionViewCell
        if let card = cardDeckOnTable[indexPath.item] {
            cellToSelect.selectCard(card: card)
            
            if let currentSelectedCardIndex = selectedCardIndexes.index(where: {$0 == indexPath}) {
                selectedCardIndexes.remove(at: currentSelectedCardIndex)
            }
            else {
                selectedCardIndexes.append(indexPath)
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
            
            animationSelectCell(cell: selectedCell)
//            animationFlipCell(cell: selectedCell)
            
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
                if soundEffectSettingOn { playSetFoundSound() }
                
                replaceCards()
                
                foundSets += 1
                game.scoreSetFound()
                
                refreshInfo()
                
                if game.isGameOver(cardDeck: cardDeck) {
                    print(">>> GAME OVER!! <<<")
                }
            }
            else {
                // deselect items
                if soundEffectSettingOn { playWrongSetSound() }
                deselectAllSelectedCells()
            }
        }
    }
    
    func checkForSet() -> Bool {
        let card1 = cardDeckOnTable[selectedCardIndexes[0].item]
        let card2 = cardDeckOnTable[selectedCardIndexes[1].item]
        let card3 = cardDeckOnTable[selectedCardIndexes[2].item]
        
        return game.checkSet(card1: card1!, card2: card2!, card3: card3!)
    }
    
    func deselectAllSelectedCells() {
        for indexpath in selectedCardIndexes {
            let selectedCell:GameCollectionViewCell = cardView.cellForItem(at: indexpath)! as! GameCollectionViewCell
            if let card = cardDeckOnTable[indexpath.item] {
                selectedCell.selectCard(card: card)
            }
        }
        selectedCardIndexes.removeAll()
    }
    
    func replaceCards() {
        let card1 = cardDeckOnTable[selectedCardIndexes[0].item]
        let card2 = cardDeckOnTable[selectedCardIndexes[1].item]
        let card3 = cardDeckOnTable[selectedCardIndexes[2].item]
        
        let cell1:GameCollectionViewCell = cardView.cellForItem(at: selectedCardIndexes[0])! as! GameCollectionViewCell
        let cell2:GameCollectionViewCell = cardView.cellForItem(at: selectedCardIndexes[1])! as! GameCollectionViewCell
        let cell3:GameCollectionViewCell = cardView.cellForItem(at: selectedCardIndexes[2])! as! GameCollectionViewCell
        
        cardDeckOnTable[selectedCardIndexes[0].item] = cardDeck.replaceCardOnTable(cardToReplace: card1!)
        cardDeckOnTable[selectedCardIndexes[1].item] = cardDeck.replaceCardOnTable(cardToReplace: card2!)
        cardDeckOnTable[selectedCardIndexes[2].item] = cardDeck.replaceCardOnTable(cardToReplace: card3!)
        
        animationFlipCell(cell: cell1, indexPath: selectedCardIndexes[0])
        animationFlipCell(cell: cell2, indexPath: selectedCardIndexes[1])
        animationFlipCell(cell: cell3, indexPath: selectedCardIndexes[2])
        
        selectedCardIndexes.removeAll()
    }
    
    func refreshInfo() {
        possibleSets = game.getPossibilitiesToMakeSet(cardDeck: cardDeckOnTable)
        cardsInDeck = cardDeck.getCardDeckRemainingCount()
        refreshScore()
        
        print("Possibilities to make a set: \(possibleSets)")
        print("Cards in deck: \(cardsInDeck)")
        print("Found sets: \(foundSets)")
        
        foundSetsLabel.text = "\(LabelConstants.foundSets) \(foundSets)"
        possibleSetsLabel.text = "\(LabelConstants.possibleSets) \(possibleSets)"
        cardsInDeckLabel.text = "\(LabelConstants.cardsInDeck) \(cardsInDeck)"
    }
    
    func refreshScore() {
        score = game.getScore()
        
        print("Score: \(game.getScore())")
        
        scoreLabel.text = "\(LabelConstants.score) \(score)"
    }
    
    // MARK: - Animations
    
    func animationSelectCell(cell: GameCollectionViewCell) {
        animationWobbleCell(cell: cell)
        
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animate(withDuration: 1.4, animations: { view.layer.opacity = 1 })
    }
    
    func animationWobbleCell(cell: GameCollectionViewCell) {
        let duration = 0.1
        let shiftFromCenter = CGFloat(2)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x += shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x -= 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 2*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x += 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 3*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x -= 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 4*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x += 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 5*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x -= 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 6*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x += 2*shiftFromCenter
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 7*duration, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
            cell.center.x -= shiftFromCenter
        }, completion: nil)
    }
    
    func animationFlipCell(cell: GameCollectionViewCell) {
        let front = cell.contentView
        let back = UIView(frame: cell.frame)
        back.backgroundColor = UIColor.black
        cell.contentView.addSubview(back)
        
        UIView.transition(from: front, to: back, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        UIView.transition(from: back, to: front, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
    }
    
    func animationFlipCell(cell: GameCollectionViewCell, indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.transition(with: cell.contentView, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromLeft, animations:  {() -> Void in
                        self.cardView.reloadItems(at: [indexPath])
                    }, completion: nil)
        }
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
