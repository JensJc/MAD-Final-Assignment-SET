//
//  HighScoresViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {
 
    let musicPlayer = MusicPlayer()
    
    @IBOutlet weak var lastBestScoreLabel: UILabel!
    @IBOutlet weak var lastBestTimeLabel: UILabel!
    @IBOutlet weak var lastFoundSetsLabel: UILabel!
    @IBOutlet weak var overallBestScoreLabel: UILabel!
    @IBOutlet weak var overallBestTimeLabel: UILabel!
    @IBOutlet weak var overallFoundSetsLabel: UILabel!
    
    private var lastBestScore: String {
        get { return lastBestScoreLabel.text! }
        set { lastBestScoreLabel.text = newValue }
    }
    private var lastBestTime: String {
        get { return lastBestScoreLabel.text! }
        set { lastBestTimeLabel.text = newValue }
    }
    private var lastFoundSets: String {
        get { return lastFoundSetsLabel.text! }
        set { lastFoundSetsLabel.text = newValue }
    }
    private var overallBestScore: String {
        get { return overallBestScoreLabel.text! }
        set { overallBestScoreLabel.text = newValue }
    }
    private var overallBestTime: String {
        get { return overallBestTimeLabel.text! }
        set { overallBestTimeLabel.text = newValue }
    }
    private var overallFoundSets: String {
        get { return overallFoundSetsLabel.text! }
        set { overallFoundSetsLabel.text = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "normaltheme.png") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        musicPlayer.playBackgroundMusic(named: "menumusic")
        
        lastBestScore = "\(UserDefaults.sharedInstance.lastScore)"
        lastBestTime = "\(round(UserDefaults.sharedInstance.lastTime))s"
        lastFoundSets = "\(UserDefaults.sharedInstance.lastFoundSets)"
        overallBestScore = "\(UserDefaults.sharedInstance.overallScore)"
        overallBestTime = "\(round(UserDefaults.sharedInstance.overallTime))s"
        overallFoundSets = "\(UserDefaults.sharedInstance.overallFoundSets)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer.stop()
    }
}
