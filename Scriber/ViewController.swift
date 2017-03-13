//
//  ViewController.swift
//  Scriber
//
//  Created by 小林 泰 on 2017/03/13.
//  Copyright © 2017年 TokyoIceHockeyChannel. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var recordButton: UIButton!
    

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        print("view loaded!")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
    }
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                print("speech recognizer authorized!")
                if let path = Bundle.main.url(forResource:"test", withExtension: "m4a") {
                    print("path configured!")
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                        print("sound played?")
                    } catch {
                        print("Error!")
                    }
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            //print(result?.bestTranscription.formattedString)
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                        }
                    }
                    
                }
                let test = Bundle.main.url(forResource:"test", withExtension: "m4a")
                if test == nil {
                    print("found nil inside path")
                }
            }
            
        }
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        print("button pressed!")
        requestSpeechAuth()
    }


}

