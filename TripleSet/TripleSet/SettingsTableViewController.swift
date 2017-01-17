//
//  SettingsTableViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

struct Difficulty {
    static let Easy = 0
    static let Normal = 1
    static let Expert = 2
}

struct Themes {
    static let Normal = 0
    static let Christmas = 1
}

struct Theme {
    static func getBackgroundImage() -> UIImage? {
        if UserDefaults.sharedInstance.theme == Themes.Christmas {
            return UIImage(named: "christmastheme")
        } else {
            return UIImage(named: "normaltheme")
        }
    }
    
    static func getColor() -> UIColor {
        if UserDefaults.sharedInstance.theme == Themes.Christmas {
            return UIColor.red
        } else {
            return UIColor.orange
        }
    }
    
    static func getGameMusic() -> String {
        if UserDefaults.sharedInstance.theme == Themes.Christmas {
            return "christmasgamemusic"
        } else {
            return "gamemusic"
        }
    }
    
    static func getMenuMusic() -> String {
        if UserDefaults.sharedInstance.theme == Themes.Christmas {
            return "christmasmenumusic"
        } else {
            return "menumusic"
        }
    }
}

class SettingsTableViewController: UITableViewController {
    // MARK: - Class Variables
    let sections = [SectionTitles.Game, SectionTitles.Sounds, SectionTitles.Themes]
    let musicPlayer = MusicPlayer()
    
    private struct SectionTitles {
        static let Game = "Game"
        static let Sounds = "Sounds"
        static let Themes = "Themes"
    }
    
    let items = [
        ["Difficulty"],
        ["Sound Effects", "Music"],
        ["Normal", "Christmas"]
    ]
    
    private struct Constants {
        static let Activated = "✔️"
        static let Deactivated = ""
    }
    
    
    // MARK: - @IBOutlets
    @IBOutlet weak var difficultySetting: UISegmentedControl! {
        didSet {
            difficultySetting.selectedSegmentIndex = UserDefaults.sharedInstance.difficulty
        }
    }
    
    @IBOutlet weak var soundEffectsSwitch: UISwitch! {
        didSet {
            soundEffectsSwitch.isOn = UserDefaults.sharedInstance.soundEffects
        }
    }
    
    @IBOutlet weak var musicSwitch: UISwitch! {
        didSet {
            musicSwitch.isOn = UserDefaults.sharedInstance.music
        }
    }
    
    @IBOutlet weak var themeNormalLabel: UILabel!
    @IBOutlet weak var themeChristmasLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel! {
        didSet{ difficultyLabel.textColor = Theme.getColor() }
    }
    @IBOutlet weak var soundEffectsLabel: UILabel!{
        didSet{ soundEffectsLabel.textColor = Theme.getColor() }
    }
    @IBOutlet weak var musicLabel: UILabel!{
        didSet{ musicLabel.textColor = Theme.getColor() }
    }
    @IBOutlet weak var normalLabel: UILabel!{
        didSet{ normalLabel.textColor = Theme.getColor() }
    }
    @IBOutlet weak var christmasLabel: UILabel!{
        didSet{ christmasLabel.textColor = Theme.getColor() }
    }
    
    // MARK: - @IBActions
    @IBAction func difficultySegmentedControlValueChanged(_ sender: UISegmentedControl) {
        if UserDefaults.sharedInstance.soundEffects { musicPlayer.playButtonClick() }
        switch sender.selectedSegmentIndex {
        case Difficulty.Easy:
            UserDefaults.sharedInstance.difficulty = Difficulty.Easy
        case Difficulty.Normal:
            UserDefaults.sharedInstance.difficulty = Difficulty.Normal
        case Difficulty.Expert:
            UserDefaults.sharedInstance.difficulty = Difficulty.Expert
        default:
            UserDefaults.sharedInstance.difficulty = Difficulty.Normal
        }
    }
    
    @IBAction func soundEffectsControlValueChanged(_ sender: UISwitch) {
        UserDefaults.sharedInstance.soundEffects = sender.isOn
        if UserDefaults.sharedInstance.soundEffects { musicPlayer.playButtonClick() }
     
    }
    
    @IBAction func musicControlValueChanged(_ sender: UISwitch) {
        UserDefaults.sharedInstance.music = sender.isOn
        
        if sender.isOn {
            musicPlayer.playBackgroundMusic(named: Theme.getMenuMusic())
        } else {
            musicPlayer.stop()
        }
    }
    
    // MARK: - Functions
    func selectTheme(theme: Int) {        
        switch theme {
        case Themes.Normal:
            themeNormalLabel.text = Constants.Activated
            themeChristmasLabel.text = Constants.Deactivated
            break
        case Themes.Christmas:
            themeNormalLabel.text = Constants.Deactivated
            themeChristmasLabel.text = Constants.Activated
            break
        default: break
        }
        
    }
    
    func refreshTheme() {
        tableView.reloadData()
        if let image = Theme.getBackgroundImage() {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        difficultyLabel.textColor = Theme.getColor()
        soundEffectsLabel.textColor = Theme.getColor()
        musicLabel.textColor = Theme.getColor()
        normalLabel.textColor = Theme.getColor()
        christmasLabel.textColor = Theme.getColor()
        
        if UserDefaults.sharedInstance.music { musicPlayer.playBackgroundMusic(named: Theme.getMenuMusic()) }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.getColor()]
    }
    
    // MARK: - Overide Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        selectTheme(theme: UserDefaults.sharedInstance.theme)
        
        if let image = Theme.getBackgroundImage() {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Theme.getColor()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
               
        if UserDefaults.sharedInstance.music { musicPlayer.playBackgroundMusic(named: Theme.getMenuMusic()) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        musicPlayer.stop()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if sections[indexPath.section] == SectionTitles.Themes {
            if UserDefaults.sharedInstance.soundEffects { musicPlayer.playButtonClick() }
            selectTheme(theme: indexPath.row)
            UserDefaults.sharedInstance.theme = indexPath.row
            refreshTheme()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = UIColor.white
        header.tintColor = Theme.getColor()
    }
}
