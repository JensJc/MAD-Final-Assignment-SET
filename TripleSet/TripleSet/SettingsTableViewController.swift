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

class SettingsTableViewController: UITableViewController {
    // MARK: - Class Variables
    let sections = [SectionTitles.Game, SectionTitles.Sounds, SectionTitles.Themes]
    
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
    
    
    // MARK: - @IBActions
    @IBAction func difficultySegmentedControlValueChanged(_ sender: UISegmentedControl) {
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
    }
    
    @IBAction func musicControlValueChanged(_ sender: UISwitch) {
        UserDefaults.sharedInstance.music = sender.isOn
    }
    
    // MARK: - Functions
    func selectTheme(theme: Int) {
        switch theme {
        case Themes.Normal:
            themeNormalLabel.text = Constants.Activated
            themeChristmasLabel.text = Constants.Deactivated
        case Themes.Christmas:
            themeNormalLabel.text = Constants.Deactivated
            themeChristmasLabel.text = Constants.Activated
            break
        default: break
        }
    }
    
    // MARK: - Overide Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        selectTheme(theme: UserDefaults.sharedInstance.theme)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            selectTheme(theme: indexPath.row)
            UserDefaults.sharedInstance.theme = indexPath.row
        }
        
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
