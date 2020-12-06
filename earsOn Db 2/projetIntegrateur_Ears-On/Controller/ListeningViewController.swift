//
//  ListeningViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/1/20.
//

import Foundation
import UIKit
import CoreData
import Speech
import AVFoundation

class listeningViewController: UIViewController , SFSpeechRecognizerDelegate, AVAudioRecorderDelegate,  UITextFieldDelegate{
    // MARK: - Outlets
    
 
    @IBOutlet weak var timeRemaining: UIProgressView!
    @IBOutlet weak var talkingButton: UIButton!
    @IBOutlet weak var txtView: UITextField!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playChoiceButton: UIButton!
    
    @IBOutlet weak var addMessagesButton: UIButton!

    // MARK: - Properties
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "fr-FR"))!
    private var speechSynthesizer = AVSpeechSynthesisVoice(language: "fr-FR")!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var timer: Timer?
    // This is an array with all the location models. It can accept a pharmacyModel, RestaurantModel, TaxiModel or anything that conforms to Location Protocol.
  
    var locations = Location.all
    var messages = FrequentMessages.all
    
    // MARK: - Settings
    
    
    func loadSettings() {
        if let identifier = UserDefaults.string(forKey: .hearLanguage),
           let language = Language(rawValue: identifier) {
            speechRecognizer = SFSpeechRecognizer(locale: language.locale)!
        }
        
        if let identifier = UserDefaults.string(forKey: .hearLanguage),
           let language = Language(rawValue: identifier) {
            speechSynthesizer = AVSpeechSynthesisVoice(language: language.rawValue)!
        }
    }
    
   // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
        messages = FrequentMessages.all
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locations = Location.all
        messages = FrequentMessages.all
        tableView.delegate = self
        tableView.dataSource = self
        dismissKeyboard()
        documentsDirectory()
        talk(talkingButton)
        microphoneButton.isEnabled = false
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError()
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
            
           
        }
        
        talkingButton.layer.cornerRadius=25.0
        microphoneButton.layer.cornerRadius=25.0
        playChoiceButton.layer.cornerRadius=25.0
        tableView.layer.cornerRadius=10.0
        addMessagesButton.layer.cornerRadius=25
        
    }
    
    @IBAction func microphoneTapped(_ sender: AnyObject) {
        if audioEngine.isRunning {
            stopRecording()
            finishRecordingAudio(success: true)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(self.remainingTime),
                                         userInfo: nil,
                                         repeats: true)
            // Swift 2.2 and objc
            //            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
            // Swift 2.3 and 3.0
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
            
            startRecording()
            startRecordingAudio()
            microphoneButton.setTitle("Arrêter", for: .normal)
        }
    }
    
    // MARK: - Methods
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.record)), mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.txtView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        txtView.text = "Dites quelque chose,je vous écoute!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    func stopRecording() {
        timer?.invalidate()
        timer = nil
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        microphoneButton.isEnabled = false
        
        microphoneButton.setTitle("Enregistrer", for: .normal)
        timeRemaining.progress = 0.0
    }
    
    // MARK: Util

    
    @objc func remainingTime() {
        print("progress: \(timeRemaining.progress)")
        timeRemaining.progress += 1.0  / 600.0
        
        if timeRemaining.progress >= 1.0 {
            stopRecording()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func documentsDirectory() {
        #if TARGET_IPHONE_SIMULATOR
            // where are you?
            print("Documents Directory: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last)")
        #endif
    }
    
    // MARK: Recording audio
    
    var audioRecorder:AVAudioRecorder?
    
    func startRecordingAudio() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recordingVoiceRecognitionDemo.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 24000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
//            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecordingAudio(success: false)
        }
    }
    
    func finishRecordingAudio(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            print("finishRecordingAudio: true")
//            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            print("finishRecordingAudio: false")
//            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    
    // MARK: AVAudioRecordingDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecordingAudio(success: false)
        }
    }
    
    internal func textFieldShouldReturn(_ txtView: UITextField) -> Bool {
       txtView.resignFirstResponder()
        return true
       }
    @objc func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
        view.endEditing(true)
    }
    
    
    //MARK: -Talking function
    @IBAction func talk(_ sender: UIButton) {
          
           if txtView.text != nil {
               myUtterance = AVSpeechUtterance(string: "\(txtView.text!)")
               myUtterance.voice = speechSynthesizer
               myUtterance.rate = 0.5
               synth.speak(myUtterance)
           }
       }
 
 
//MARK: - Playing the message

       @IBAction func playMessage() {
        let indexPath = tableView.indexPathForSelectedRow
        if indexPath != nil{
            let message = messages[indexPath!.section][indexPath!.row]
        myUtterance = AVSpeechUtterance(string: "\(message)")
        myUtterance.voice = speechSynthesizer
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
        }
        }
       }
    
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
 
