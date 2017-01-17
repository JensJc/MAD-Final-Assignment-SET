//
//  MusicPlayer.swift
//  TripleSet
//
//  Created by developer on 16/01/2017.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import AVFoundation

struct Music {
    static let Menu = "menumusic"
    static let MenuChristmas = "christmasmenumusic"
    static let Game = "gamemusic"
    static let GameChristmas = "christmasgamemusic"
}

class MusicPlayer {
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var buttonSoundPlayer: AVAudioPlayer?
    
    private struct Sounds {
        static let CardClick = "cardclick"
        static let SetFound = "setfound"
        static let WrongSet = "wrongset"
        static let ButtonClick = "buttonclick"
    }
    
    func playBackgroundMusic(named: String) {
        if UserDefaults.sharedInstance.music {
            let url = Bundle.main.url(forResource: named, withExtension: "mp3")!
            
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
    
    func playButtonClick() {
        playSound(soundDescription: Sounds.ButtonClick)
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
    
    func stop() {
        backgroundMusicPlayer?.stop()
    }

}
