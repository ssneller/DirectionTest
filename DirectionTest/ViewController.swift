//
//  ViewController.swift
//  DirectionTest
//
//  Created by Steve Sneller on 12/26/15.
//  Copyright © 2015 SteveSneller. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import AVFoundation //  , AVSpeechSynthesizerDelegate

class ViewController: UIViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var utteranceLabel: UILabel!
    @IBOutlet weak var distanceReading: UILabel!
    
    var direction: String!
    var voice = AVSpeechSynthesizer()//let v = AVSpeechSynthesisVoice(language: "en-U
    var v = AVSpeechSynthesisVoice(language: "en-US")
    var utterance : AVSpeechUtterance!
    
    var snd : String!
    var sndType : String!
    var playNorth : AVAudioPlayer?
    var playSouth : AVAudioPlayer?
    var playWest : AVAudioPlayer?
    var playEast : AVAudioPlayer?
    var playNorthEast : AVAudioPlayer?
    var playSouthEast : AVAudioPlayer?
    var playNorthWest : AVAudioPlayer?
    var playSouthWest : AVAudioPlayer?
//    var secondBeep : AVAudioPlayer?
//    var backgroundMusic : AVAudioPlayer?
    var myLocations: [CLLocation] = []
    var beaconRegion: CLBeaconRegion!
    var locationManager: CLLocationManager!
    var isSearchingForBeacons = false
    var lastFoundBeacon: CLBeacon! = CLBeacon()
    var lastProximity: CLProximity! = CLProximity.Unknown
    
//    let uuid = NSUUID(UUIDString: "8B400324-8C59-841F-65EE-049D9E930582")
    var uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        //2
        var audioPlayer:AVAudioPlayer?
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        return audioPlayer
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup sounds
        if let playNorth = self.setupAudioPlayerWithFile("north", type: "wav") {self.playNorth = playNorth}
        if let playSouth = self.setupAudioPlayerWithFile("south", type: "wav") {self.playSouth = playSouth}
        if let playEast = self.setupAudioPlayerWithFile("east", type: "wav") {self.playEast = playEast}
        if let playWest = self.setupAudioPlayerWithFile("west", type: "wav") {self.playWest = playWest}
        if let playNorthEast = self.setupAudioPlayerWithFile("northeast", type: "wav") {self.playNorthEast = playNorthEast}
        if let playSouthEast = self.setupAudioPlayerWithFile("southeast", type: "wav") {self.playSouthEast = playSouthEast}
        if let playNorthWest = self.setupAudioPlayerWithFile("northwest", type: "wav") {self.playNorthWest = playNorthWest}
        if let playSouthWest = self.setupAudioPlayerWithFile("southwest", type: "wav") {self.playSouthWest = playSouthWest}
        
        // create location manager for location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // get location
       // locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // setup heading
        locationManager.headingFilter = 5
        locationManager.startUpdatingHeading()
        // start ranging
        beaconRegion = CLBeaconRegion(proximityUUID: uuid!, identifier: "com.ssneller.DirectionTest")
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        locationManager.startRangingBeaconsInRegion(beaconRegion)
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startUpdatingHeading()
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
        print("scanning")
        
        
        } // close of VDL
    
    //gets location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){print(locations);locationManager.stopUpdatingLocation()}
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){print("Errors: " + error.localizedDescription)}
   
    // this function gives the phone heading and announces direction
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.magneticHeading) // maybe???
        
        var head = CGFloat((locationManager.heading?.trueHeading)!) // cast to CGfloat for value
        
        if head > 27.5 && head <= 72.5{ // 45 degree offsets for each value
            print("NE")
            playNorthEast?.volume = 0.1
            playNorthEast?.play()
        }else if head > 72.5 && head <= 117.5{
            print("E")
            playEast?.volume = 0.1
            playEast?.play()
        }else if head > 117.5 && head <= 162.5{
            print("SE")
            playSouthEast?.volume = 0.1
            playSouthEast?.play()
        }else if head > 162.5 && head <= 207.5{
            print("S")
            playSouth?.volume = 0.1
            playSouth?.play()
        }else if head > 207.5 && head <= 252.5{
            print("SW")
            playSouthWest?.volume = 0.1
            playSouthWest?.play()
        }else if head > 252.5 && head <= 297.5{
            print("W")
            playWest?.volume = 0.1
            playWest?.play()
        }else if head > 297.5 && head <= 342.5{
            print("NW")
            playNorthWest?.volume = 0.1
            playNorthWest?.play()
        }else if head > 342.5 || head <= 27.5{
            print("N")
            playNorth?.volume = 0.1
            playNorth?.play()
        }else{
            print("unknown heading")
        }
    }
/*
    func startScanning() {
        //let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
       // let uuid = NSUUID(UUIDString: "8B400324-8C59-841F-65EE-049D9E930582")
                let uuid = NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        
        print("scanning")
        
    //    let beaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: 1233, minor: 1, identifier: "MyBeacon")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "LivingRoom")
        locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
 */
    func updateDistance(distance: CLProximity) {
        
        UIView.animateWithDuration(0.8) { [unowned self] in
            switch distance {
            case .Unknown:
                self.view.backgroundColor = UIColor.grayColor()
                self.distanceReading.text = "UNKNOWN"
                
            case .Far:
                self.view.backgroundColor = UIColor.blueColor()
                self.distanceReading.text = "FAR"
                
            case .Near:
                self.view.backgroundColor = UIColor.orangeColor()
                self.distanceReading.text = "NEAR"
                self.utterance = AVSpeechUtterance(string: (self.distanceReading.text)!)
            //    self.utterance = AVSpeechUtterance(string:"Turn west to go to the library or turn east to go to the office")
                self.utterance.rate = 0.4
        //        self.voice.speakUtterance(self.utterance)
                self.voice.pauseSpeakingAtBoundary(.Word)
            case .Immediate:
                self.view.backgroundColor = UIColor.redColor()
                self.distanceReading.text = "RIGHT HERE"
        //        self.utterance = AVSpeechUtterance(string:"Turn west to go to the library or turn east to go to the office")
                self.utterance.rate = 0.4
                self.voice.speakUtterance(self.utterance)
                self.voice.pauseSpeakingAtBoundary(.Word)
            }
        }
    }
    
    
    // checks for closest beacon
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            
            print("beacon is \(closestBeacon.minor.integerValue)")
            
            var beaconMinor: Int = closestBeacon.minor.integerValue
            
           
  /*
            utterance = AVSpeechUtterance(string:"your are at beacon \(beaconMinor)")
            utterance.rate = 0.4
            utterance.pitchMultiplier = 0.5
            utterance.volume = 0.5
     //       voice.speakUtterance(utterance)
            utterance.voice = v
            voice.pauseSpeakingAtBoundary(.Word)
     */
            
            
            switch beaconMinor {
                
                
            case 1:
                print("1")
                utterance = AVSpeechUtterance(string:"you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.rate = 0.4
                utterance.pitchMultiplier = 0.5
                utterance.volume = 0.5
                voice.speakUtterance(utterance)
                //         voice.pauseSpeakingAtBoundary(.Word)
            case 2:
                print("2")
                utterance = AVSpeechUtterance(string:"you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.rate = 0.4
                utterance.pitchMultiplier = 0.5
                utterance.volume = 0.5
                voice.speakUtterance(utterance)
                //         voice.pauseSpeakingAtBoundary(.Word)
            case 3:
                print("3")
                utterance = AVSpeechUtterance(string:"you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.rate = 0.4
                utterance.pitchMultiplier = 0.5
                utterance.volume = 0.5
                voice.speakUtterance(utterance)
                //         voice.pauseSpeakingAtBoundary(.Word)
            case 4:
                print("4")
                utterance = AVSpeechUtterance(string:"Steve you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

                utterance.rate = 0.4
           //     utterance.pitchMultiplier = 0.5
          //      utterance.volume = 0.5
                voice.speakUtterance(utterance)
                
                         voice.pauseSpeakingAtBoundary(.Word)
            case 5:
                print("5")
                utterance = AVSpeechUtterance(string:"you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.rate = 0.4
                utterance.pitchMultiplier = 0.5
                utterance.volume = 0.5
                voice.speakUtterance(utterance)
                //         voice.pauseSpeakingAtBoundary(.Word)
            case 6:
                print("6")
                utterance = AVSpeechUtterance(string:"you are at beacon \(beaconMinor) Turn west to go to the library or turn east to go to the office")
                utterance.rate = 0.4
                utterance.pitchMultiplier = 0.5
                utterance.volume = 0.5
                voice.speakUtterance(utterance)
                //         voice.pauseSpeakingAtBoundary(.Word)
            default:
                print("default")
                
            }
                  
            
            if beacons.count > 0 {
                let beacon = beacons[0]
                updateDistance(beacon.proximity)
            } else {
                updateDistance(.Unknown)
            }
            
            
            
            
            //            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue]
        }
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
        print("starting")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        print("finished")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        utteranceLabel.attributedText = mutableAttributedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//}


//var utteranceLabel: UILabel!   // distanceReading

//var utteranceLabel = distanceReading

// MARK: AVSpeechSynthesizerDelegate
    /*

        func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
            print("starting")
        }

        func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
            print("finished")
        }

        func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
            let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
            mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
            utteranceLabel.attributedText = mutableAttributedString
        }
}
*/
//func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
//utteranceLabel.attributedText = NSAttributedString(string: utterance.speechString)
//}

/*
 func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
 print("starting")
 }
 
 func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
 print("finished")
 }
 
 func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
 let s = (utterance.speechString as NSString).substringWithRange(characterRange)
 print("about to say \(s)")
 }
 
*/



/*
func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
if status == .AuthorizedAlways {
if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
if CLLocationManager.isRangingAvailable() {
startScanning()
}
}
}
}

func startScanning() {
//let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
let uuid = NSUUID(UUIDString: "07775DD0-111B-11E4-9191-0800200C9A66")!
//        let uuid = NSUUID(UUIDString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 6400, minor: 15714, identifier: "MyBeacon")

locationManager.startMonitoringForRegion(beaconRegion)
locationManager.startRangingBeaconsInRegion(beaconRegion)
}

func updateDistance(distance: CLProximity) {
UIView.animateWithDuration(0.8) { [unowned self] in
switch distance {
case .Unknown:
self.view.backgroundColor = UIColor.grayColor()
self.distanceReading.text = "UNKNOWN"

case .Far:
self.view.backgroundColor = UIColor.blueColor()
self.distanceReading.text = "FAR"

case .Near:
self.view.backgroundColor = UIColor.orangeColor()
self.distanceReading.text = "NEAR"

case .Immediate:
self.view.backgroundColor = UIColor.redColor()
self.distanceReading.text = "RIGHT HERE"
}
}
}

func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
if beacons.count > 0 {
let beacon = beacons[0]
updateDistance(beacon.proximity)
} else {
updateDistance(.Unknown)
}
}

*/

/*

let utterance = AVSpeechUtterance(string:"This is an emergency. Please send emergency responders to this address,     \(fullAddress)")
// // plays sound is speech enabled
let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
if (defaults.objectForKey("SwitchStateSound") != nil) {
pSound = defaults.boolForKey("SwitchStateSound")
if pSound.boolValue == true {
utterance.rate = 0.05
utterance.pitchMultiplier = 0.7
utterance.volume = 1.0
voice.speakUtterance(utterance)
print(utterance)

*/

