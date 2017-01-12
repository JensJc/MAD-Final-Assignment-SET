//
//  HighScoresViewController.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 05-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {
    
    @IBOutlet weak var todayBestScoreLabel: UILabel!
    @IBOutlet weak var todayBestTimeLabel: UILabel!
    @IBOutlet weak var overallBestScoreLabel: UILabel!
    @IBOutlet weak var overallBestTimeLabel: UILabel!
    
    private var todayBestScore: String {
        get { return todayBestScoreLabel.text! }
        set { todayBestScoreLabel.text = newValue }
    }
    private var todayBestTime: String {
        get { return todayBestScoreLabel.text! }
        set { todayBestTimeLabel.text = newValue }
    }
    private var overallBestScore: String {
        get { return overallBestScoreLabel.text! }
        set { overallBestScoreLabel.text = newValue }
    }
    private var overallBestTime: String {
        get { return overallBestTimeLabel.text! }
        set { overallBestTimeLabel.text = newValue }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = UIImage(named: "normaltheme.png") {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        // Do any additional setup after loading the view.
        todayBestScore = "4500"
        todayBestTime = "04:57"
        overallBestScore = "3750"
        overallBestTime = "04:16"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
