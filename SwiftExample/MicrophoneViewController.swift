//
//  MicrophoneViewController.swift
//  SwiftExample
//
//  Created by LvApril on 9/12/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import AVFoundation

protocol MicrophoneViewControllerDelegate {
    func sendVoiceMsg(fu: NSURL)
}
class MicrophoneViewController: UIViewController, AVAudioRecorderDelegate  {

    var delegate : MicrophoneViewControllerDelegate?
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var Microphone: UIButton!{
        didSet{
            Microphone.layer.cornerRadius = 5.0
        }
    }
    
    @IBAction func stopRecord(sender: AnyObject) {
        
    }
    @IBAction func sendAudio(sender: UIButton) {
//        if let title = sender.currentTitle {
//            if title == "Send" {
//                
//            }
//        }
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
//        recordButton.setTitle("Tap to Record", forState: .Normal)
//        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
//        recordButton.addTarget(self, action: #selector(recordTapped), forControlEvents: .TouchUpInside)
//        view.addSubview(recordButton)
    }
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return paths[0]
        
    }
    
    func getFileURL() -> NSURL{
        let path  = (getCacheDirectory() as NSString).stringByAppendingPathComponent("recording.m4a")
        
        let filePath = NSURL(fileURLWithPath: path)
        
        
        return filePath
    }
    
//    func getDocumentsDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
    
    var recodingUrl : NSURL?
    func startRecording() {
//        let audioFilename = getFileURL()
        let audioURL = getFileURL()
        recodingUrl = audioURL
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            if audioRecorder.prepareToRecord() {
                audioRecorder.record()
            }
            
            
            Microphone.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        
        audioRecorder.stop()
//        audioRecorder = nil
       
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print(error)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(recorder.url, recorder.currentTime, recorder)
        if flag {
            if let del = self.delegate {
                del.sendVoiceMsg(recodingUrl!)
                self.dismissViewControllerAnimated(true, completion: {
                })
            }
            
        } else {
            if let del = self.delegate {
                del.sendVoiceMsg(recodingUrl!)
                self.dismissViewControllerAnimated(true, completion: {
                })
            }
            Microphone.setTitle("Hold to Talk", forState: .Normal)
        }
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
