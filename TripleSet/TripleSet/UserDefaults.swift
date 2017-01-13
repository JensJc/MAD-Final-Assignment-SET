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
    
}
