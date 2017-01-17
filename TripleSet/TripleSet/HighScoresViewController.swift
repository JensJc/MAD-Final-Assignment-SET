//
//  HighScoresViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit
import SceneKit

class HighScoresViewController: UIViewController {
 
    let musicPlayer = MusicPlayer()
    var snowView: SnowFallingView?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lastgameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var foundSetLastLabel: UILabel!
    
    @IBOutlet weak var lastBestScoreLabel: UILabel!
    @IBOutlet weak var lastBestTimeLabel: UILabel!
    @IBOutlet weak var lastFoundSetsLabel: UILabel!
    
    @IBOutlet weak var overallLabel: UILabel!
    
    @IBOutlet weak var foundSetOverallLabel: UILabel!
    @IBOutlet weak var scoreOverallLabel: UILabel!
    @IBOutlet weak var timeOverallLabel: UILabel!
    
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

        if let image = Theme.getBackgroundImage() {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        setLabelColors()
        
        musicPlayer.playBackgroundMusic(named: Theme.getMenuMusic())
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.sharedInstance.theme == Themes.Christmas { addSnowView() }
    }

    func setLabelColors() {
        titleLabel.textColor = Theme.getColor()
        
        lastgameLabel.textColor = Theme.getColor()
        scoreLabel.textColor = Theme.getColor()
        timeLabel.textColor = Theme.getColor()
        foundSetLastLabel.textColor = Theme.getColor()
        lastBestScoreLabel.textColor = Theme.getColor()
        lastBestTimeLabel.textColor = Theme.getColor()
        lastFoundSetsLabel.textColor = Theme.getColor()
        
        overallLabel.textColor = Theme.getColor()
        scoreOverallLabel.textColor = Theme.getColor()
        timeOverallLabel.textColor = Theme.getColor()
        foundSetOverallLabel.textColor = Theme.getColor()
        overallBestScoreLabel.textColor = Theme.getColor()
        overallBestTimeLabel.textColor = Theme.getColor()
        overallFoundSetsLabel.textColor = Theme.getColor()
    }
    
    // MARK: - Animations
    
    func addSnowView() {
        snowView = SnowFallingView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width * 2, height: view.frame.size.height * 2))
        view.addSubview(snowView!)
        view.sendSubview(toBack: snowView!)
        snowView?.startSnow()
    }
}
