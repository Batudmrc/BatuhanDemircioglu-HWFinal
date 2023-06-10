//
//  AudioManager.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 10.06.2023.
//

import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    var currentPlayingUrl: URL?
    var isPaused: Bool = false
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func playAudio(from url: URL) {
        if isPaused, let audioPlayer = audioPlayer, currentPlayingUrl == url {
            audioPlayer.play()
            isPaused = false
        } else {
            stopAudio()
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let audioPlayer = try? AVAudioPlayer(data: data) else {
                    print("Failed to load audio data: \(error?.localizedDescription ?? "")")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.audioPlayer = audioPlayer
                    self?.audioPlayer?.play()
                    self?.currentPlayingUrl = url
                    self?.isPaused = false
                }
            }.resume()
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPaused = true
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        currentPlayingUrl = nil
        isPaused = false
    }
}




