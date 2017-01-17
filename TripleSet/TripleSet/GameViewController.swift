//
//  GameViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let musicPlayer = MusicPlayer()
    let reuseIdentifier = "cell"
    
    let game: Game = Game()
    
    var cardDeckOnTable = [Card?]()
    var selectedCardIndexes = [IndexPath]()
    
    var score: Int = 0
    var foundSets: Int = 0
    var possibleSets: Int = 0
    var cardsInDeck: Int = 0
    
    var soundEffectSettingOn = false
    var musicSettingOn = false
    
    private struct LabelConstants {
        static let score = "Score:"
        static let foundSets = "Found sets:"
        static let possibleSets = "Possible Sets:"
        static let cardsInDeck = "Cards in deck:"
        
    }
    
    // MARK: - Outlets and Actions

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
        if soundEffectSettingOn { musicPlayer.playButtonClick() }
        shuffleCards()
    }
    
    @IBAction func hintButtonClicked(_ sender: UIButton) {
        if soundEffectSettingOn { musicPlayer.playButtonClick() }
        
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
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "normaltheme.png") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
                
        soundEffectSettingOn = UserDefaults.sharedInstance.soundEffects
        musicSettingOn = UserDefaults.sharedInstance.music
        
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if musicSettingOn { musicPlayer.playBackgroundMusic(named: "gamemusic") }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer.stop()
    }
    
    // MARK: - Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardDeck.amountCardsOnTable
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! GameCollectionViewCell
        
        if let card = cardDeckOnTable[indexPath.item] {
            cell.setCard(card: card)
        }
        else {
            cell.setEmpty()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if soundEffectSettingOn { musicPlayer.playCardClickSound() }

        let selectedCell:GameCollectionViewCell = collectionView.cellForItem(at: indexPath)! as! GameCollectionViewCell
        if let card = cardDeckOnTable[indexPath.item] {
            
            animationSelectCell(cell: selectedCell)
            
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
    
    // MARK: - Functions
    
    func startGame() {
        game.start()
        cardDeckOnTable = game.getCardsOnTable()

        game.setTests()
        refreshInfo()
    }
    
    func tryToCheckForSet(_ collectionView: UICollectionView) {
        if selectedCardIndexes.count == 3 {

            let setFound = checkForSet()
            print("setFound: \(setFound)")
            
            if setFound {
                if soundEffectSettingOn { musicPlayer.playSetFoundSound() }
                
                replaceCards()
                
                foundSets += 1
                game.scoreSetFound()
                
                refreshInfo()
                
                if game.isGameOver() {
                    gameOverAlert()
                }
            }
            else {
                // deselect items
                if soundEffectSettingOn { musicPlayer.playWrongSetSound() }
                deselectAllSelectedCells()
            }
        }
    }
    
    func gameOverAlert() {
        updateHighScores()
        
        let alert = UIAlertController(title: "All SET's found!", message: "Congratulations, you've found all possible SET's!", preferredStyle: UIAlertControllerStyle.alert)
        let newGameAction = UIAlertAction(title: "New game", style: UIAlertActionStyle.cancel) { (action: UIAlertAction!) in
            
             UIView.transition(with: self.view, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {}, completion: nil)
            self.startGame()
            self.cardView.reloadData()
        }
        
        alert.addAction(newGameAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateHighScores() {
        let time: Double = game.getElapsedTime()
        
        UserDefaults.sharedInstance.lastScore = score
        UserDefaults.sharedInstance.lastTime = time
        UserDefaults.sharedInstance.lastFoundSets = foundSets
        
        if score > UserDefaults.sharedInstance.overallScore {
            UserDefaults.sharedInstance.overallScore = score
        }
        
        if time < UserDefaults.sharedInstance.overallTime || time == 0.0 {
            UserDefaults.sharedInstance.overallTime = time
        }
        
        if foundSets > UserDefaults.sharedInstance.overallFoundSets {
            UserDefaults.sharedInstance.overallFoundSets = foundSets
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
        
        cardDeckOnTable[selectedCardIndexes[0].item] = game.replaceCardOnTable(card: card1!)
        cardDeckOnTable[selectedCardIndexes[1].item] = game.replaceCardOnTable(card: card2!)
        cardDeckOnTable[selectedCardIndexes[2].item] = game.replaceCardOnTable(card: card3!)
        
        animationFlipCell(cell: cell1, indexPath: selectedCardIndexes[0])
        animationFlipCell(cell: cell2, indexPath: selectedCardIndexes[1])
        animationFlipCell(cell: cell3, indexPath: selectedCardIndexes[2])
        
        selectedCardIndexes.removeAll()
    }
    
    func refreshInfo() {
        possibleSets = game.getPossibilitiesToMakeSet(cardDeck: cardDeckOnTable)
        cardsInDeck = game.getRemaingCardDeckCount()
        refreshScore()
        
        print("Possibilities to make a set: \(possibleSets)")
        print("Cards in deck: \(cardsInDeck)")
        print("Found sets: \(foundSets)")
        
        foundSetsLabel.text = "\(LabelConstants.foundSets) \(foundSets)"
        possibleSetsLabel.text = "\(LabelConstants.possibleSets) \(possibleSets)"
        cardsInDeckLabel.text = "\(LabelConstants.cardsInDeck) \(cardsInDeck)"
        
        if possibleSets == 0 && cardsInDeck != 0{
            UIView.transition(with: cardView, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {}, completion: nil)
            shuffleCards()
        }
    }
    
    func refreshScore() {
        score = game.getScore()
        
        print("Score: \(game.getScore())")
        
        scoreLabel.text = "\(LabelConstants.score) \(score)"
    }
    
    func shuffleCards() {
        deselectAllSelectedCells()
                
        cardDeckOnTable = game.shuffleCards()
        cardView.reloadData()
        
        refreshInfo()
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
  }
