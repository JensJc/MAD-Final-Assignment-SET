//
//  MenuViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var buttonSoundPlayer: AVAudioPlayer?
    
    var soundEffectSettingOn = false
    var musicSettingOn = false
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "normaltheme.png") {
             self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        if let image = UIImage(named: "logo.png") {
            logoImage.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAppear()
        
        soundEffectSettingOn = UserDefaults.sharedInstance.soundEffects
        musicSettingOn = UserDefaults.sharedInstance.music
        
        if musicSettingOn { playBackgroundMusic() }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer?.stop()
        }
    }
    
    @IBAction func playClick(_ sender: Any) {
        if soundEffectSettingOn { buttonClickSound() }
    }
    @IBAction func highscoresClick(_ sender: Any) {
        if soundEffectSettingOn { buttonClickSound() }
    }
    @IBAction func settingsClick(_ sender: Any) {
        if soundEffectSettingOn { buttonClickSound() }
    }
    
    // MARK: - Sounds and Animation
    
    func logoAppear() {
        UIView.transition(with: logoImage, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {}, completion: nil)
    }
    
    func playBackgroundMusic() {
        let url = Bundle.main.url(forResource: "menumusic", withExtension: "mp3")!
        
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
    
    func buttonClickSound() {
        let url = Bundle.main.url(forResource: "buttonclick", withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            
            buttonSoundPlayer = player
            
            buttonSoundPlayer?.prepareToPlay()
            buttonSoundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
