//
//  UserDefaults.swift
//  TripleSet
//
//  Created by Matthieu de Wit on 13-01-17.
//  Copyright © 2017 MdW Development. All rights reserved.
//

import Foundation

class UserDefaults {
    static let sharedInstance = UserDefaults()
    
    private init() {}
    private let defaults = Foundation.UserDefaults.standard
    
    struct Constants {
        static let DefaultDifficultyKey = "Difficulty"
        static let DefaultDifficultySetting = Difficulty.Normal
        
        static let DefaultSoundEffectKey = "SoundEffects"
        static let DefaultSoundEffectSetting = true
        
        static let DefaultMusicKey = "Music"
        static let DefaultMusicSetting = true
        
        static let DefaultThemeKey = "Theme"
        static let DefaultThemeSetting = Themes.Normal
        
        static let DefaultLastScoreKey = "LastScore"
        static let DefaultLastScore = 0
        
        static let DefaultLastTimeKey = "LastTime"
        static let DefaultLastTime = 0.0
        
        static let DefaultLastFoundSetsKey = "LastFoundSets"
        static let DefaultLastFoundSets = 0
        
        static let DefaultOverallScoreKey = "OverallScore"
        static let DefaultOverallScore = 0
        
        static let DefaultOverallTimeKey = "OverallTime"
        static let DefaultOverallTime = 0.0
        
        static let DefaultOverallFoundSetsKey = "OverallFoundSets"
        static let DefaultOverallFoundSets = 0
    }
    
    var difficulty: Int {
        get {
            if let defaultDifficulty = defaults.object(forKey: Constants.DefaultDifficultyKey) as? Int {
                return defaultDifficulty
            } else {
                return Constants.DefaultDifficultySetting
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultDifficultyKey)
            defaults.synchronize()
        }
    }
    
    var soundEffects: Bool {
        get {
            if let defaultSoundEffectSetting = defaults.object(forKey: Constants.DefaultSoundEffectKey) as? Bool {
                return defaultSoundEffectSetting
            } else {
                return Constants.DefaultSoundEffectSetting
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultSoundEffectKey)
            defaults.synchronize()
        }
    }
    
    var music: Bool {
        get {
            if let defaultMusicSetting = defaults.object(forKey: Constants.DefaultMusicKey) as? Bool {
                return defaultMusicSetting
            } else {
                return Constants.DefaultMusicSetting
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultMusicKey)
            defaults.synchronize()
        }
    }
    
    var theme: Int {
        get {
            if let defaultThemeSetting = defaults.object(forKey: Constants.DefaultThemeKey) as? Int {
                return defaultThemeSetting
            } else {
                return Constants.DefaultThemeSetting
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultThemeKey)
            defaults.synchronize()
        }
    }
    
    var lastScore: Int {
        get {
            if let defaultLastScore = defaults.object(forKey: Constants.DefaultLastScoreKey) as? Int {
                return defaultLastScore
            } else {
                return Constants.DefaultLastScore
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultLastScoreKey)
            defaults.synchronize()
        }
    }
    
    var lastTime: Double {
        get {
            if let defaultLastTime = defaults.object(forKey: Constants.DefaultLastTimeKey) as? Double {
                return defaultLastTime
            } else {
                return Constants.DefaultLastTime
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultLastTimeKey)
            defaults.synchronize()
        }
    }
    
    var lastFoundSets: Int {
        get {
            if let defaultLastFoundSets = defaults.object(forKey: Constants.DefaultLastFoundSetsKey) as? Int {
                return defaultLastFoundSets
            } else {
                return Constants.DefaultLastFoundSets
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultLastFoundSetsKey)
            defaults.synchronize()
        }
    }
    
    var overallScore: Int {
        get {
            if let defaultOverallScore = defaults.object(forKey: Constants.DefaultOverallScoreKey) as? Int {
                return defaultOverallScore
            } else {
                return Constants.DefaultOverallScore
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultOverallScoreKey)
            defaults.synchronize()
        }
    }
    
    var overallTime: Double {
        get {
            if let defaultOverallTime = defaults.object(forKey: Constants.DefaultOverallTimeKey) as? Double {
                return defaultOverallTime
            } else {
                return Constants.DefaultOverallTime
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultOverallTimeKey)
            defaults.synchronize()
        }
    }
    
    var overallFoundSets: Int {
        get {
            if let defaultOverallFoundSets = defaults.object(forKey: Constants.DefaultOverallFoundSetsKey) as? Int {
                return defaultOverallFoundSets
            } else {
                return Constants.DefaultOverallFoundSets
            }
        }
        set {
            defaults.set(newValue, forKey: Constants.DefaultOverallFoundSetsKey)
            defaults.synchronize()
        }
    }
    
    
}
