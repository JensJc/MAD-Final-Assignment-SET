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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highscoresButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let musicPlayer = MusicPlayer()
    
    var soundEffectSettingOn = false
    var musicSettingOn = false
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.red
           
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let image = Theme.getBackgroundImage() {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        if let image = UIImage(named: "logo.png") {
            logoImage.image = image.withRenderingMode(.alwaysTemplate)
            logoImage.tintColor = Theme.getColor()
        }

        playButton.setTitleColor(Theme.getColor(), for: .normal)
        highscoresButton.setTitleColor(Theme.getColor(), for: .normal)
        settingsButton.setTitleColor(Theme.getColor(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        logoAppear()
        
        soundEffectSettingOn = UserDefaults.sharedInstance.soundEffects
        musicSettingOn = UserDefaults.sharedInstance.music
        
        if musicSettingOn { musicPlayer.playBackgroundMusic(named: Theme.getMenuMusic()) }
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
