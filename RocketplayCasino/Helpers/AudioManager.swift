//
//  AudioManager.swift
//  RocketplayCasino
//
//  Created by Alina Bondarchuk on 12.09.2024.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private let defaults = UserDefaults.standard
    var backgroundPlayer: AVAudioPlayer?
    var currentAudioPlayer: AVAudioPlayer?
    
    private var backgroundVolume: Float = 0.3
    private var soundVolume: Float = 0.5
    
    var isSoundOff: Bool {
        get { return defaults.bool(forKey: "soundOff") }
        set {
            defaults.setValue(newValue, forKey: "soundOff")
            defaults.synchronize()
        }
    }
    
    func playBackgroundMusic() {
        guard !isSoundOff else { return }
        DispatchQueue.global().async { [self] in
            guard let music = Bundle.main.path(forResource: "background", ofType: "mp3") else {
                print("Background Music file not found")
                return
            }
            do {
                backgroundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music))
                backgroundPlayer?.volume = backgroundVolume
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stopBackgroundMusic() {
        DispatchQueue.global().async { [self] in
            backgroundPlayer?.stop()
        }
    }
    
    func playSounds(_ soundName: String, loop: Bool = false) {
        guard !isSoundOff else { return }
        DispatchQueue.global().async { [self] in
            
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
                print("Sound effect file not found: \(soundName)")
                return
            }
            currentAudioPlayer?.stop()
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.volume = soundVolume
                if loop {
                    player.numberOfLoops = -1
                }
                player.play()
                currentAudioPlayer = player
            } catch {
                print("Sound effect error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func stopSounds() {
        DispatchQueue.global().async { [self] in
            currentAudioPlayer?.stop()
            currentAudioPlayer = nil
        }
    }
}
