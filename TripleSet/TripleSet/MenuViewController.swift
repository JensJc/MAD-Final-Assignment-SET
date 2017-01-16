//
//  MenuViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let musicPlayer = MusicPlayer()
    
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
        
        if musicSettingOn { musicPlayer.playBackgroundMusic(named: "menumusic") }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer.stop()
    }
    
    @IBAction func playClick(_ sender: Any) {
        if soundEffectSettingOn { musicPlayer.playButtonClick() }
    }
    @IBAction func highscoresClick(_ sender: Any) {
        if soundEffectSettingOn { musicPlayer.playButtonClick() }
    }
    @IBAction func settingsClick(_ sender: Any) {
        if soundEffectSettingOn { musicPlayer.playButtonClick() }
    }
    
    // MARK: - Animation
    
    func logoAppear() {
        UIView.transition(with: logoImage, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {}, completion: nil)
    }
}
