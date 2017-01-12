//
//  GameViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    var backgroundMusicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "normaltheme.png") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
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
