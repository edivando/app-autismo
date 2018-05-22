//
//  Speech.swift
//  Antonio Freitas
//
//  Created by Ramon on 4/21/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import AVFoundation

class Speech: NSObject,AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()
    
    
    var isSpeaking = false
    
    deinit {
        //print("fui embora")
    }
    
    func speak (text: String) {
        synthesizer.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stopAudio:", name:"StopAudio", object: nil)
        if !isSpeaking {
            let textToSynthesise = text
            let utterance = AVSpeechUtterance(string: textToSynthesise) //send the text to be synthesised
            utterance.voice = AVSpeechSynthesisVoice(language: "language".localized)
            
            if #available(iOS 9.0, *) {
                utterance.rate = 0.4 // speed of the voice 0-1(low values are slower here)
            } else {
                utterance.rate = 0.1 // speed of the voice 0-1(low values are slower here)
            }
            
            isSpeaking = true
            synthesizer.speakUtterance(utterance) //send the
        } else {
            stopSpeech()
        }
    }
    
    func stopSpeech () {
        isSpeaking = false
        synthesizer.stopSpeakingAtBoundary(.Immediate) //stop the speech immediatly to start another speech
    }
    
    func stopAudio (notification: NSNotification) {
        isSpeaking = false
        synthesizer.stopSpeakingAtBoundary(.Immediate) //stop the speech immediatly to start another speech
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
        //print("cancel")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        //print("finished")
        stopSpeech()
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didPauseSpeechUtterance utterance: AVSpeechUtterance) {
        //print("paused")
    }
}
