//
//  ViewController.swift
//  Baby in car check IOS
//
//  Created by Areeb Waseem on 6/5/18.
//  Copyright © 2018 Areeb Waseem. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import AVFoundation
import MediaPlayer
import QuartzCore

class ViewController: UIViewController, CLLocationManagerDelegate,AVAudioPlayerDelegate {
    
   
    
    
    
    var audio_plauyer : AVAudioPlayer!
    
    @IBOutlet weak var baby_in_car_check_logo: UILabel!
    
    let locationManager = CLLocationManager()
    
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "27cf161a-df24-43f2-a5a2-049dacf221d1")! as UUID, identifier: "Estimots")
    
    @IBOutlet weak var next_button_rounded: UIButton!
    
    @IBOutlet weak var starter_congo_view: UIView!
    
    @IBOutlet weak var sunny_view: UIImageView!
    
    @IBAction func next_button(_ sender: UIButton) {
        
        
        
        performSegue(withIdentifier: "first_to_second_segue", sender: self)
        
        
        
    }
    
    
    
    @IBAction func dismiss_button(_ sender: UIButton) {
        
        starter_congo_view.isHidden = true
        
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func stop_monitoring(_ sender: UIButton) {
        
        /*
        let sound_url = Bundle.main.url(forResource: "alarm_tone", withExtension: "mp3")
        do {
            audio_plauyer = try AVAudioPlayer(contentsOf: sound_url!)
        }catch{
            print(error)
        }
        
        
        do {
           // try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            /*
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
            UIApplication.shared.beginReceivingRemoteControlEvents()
 */
            // Removed deprecated use of AVAudioSessionDelegate protocol
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
           // try AVAudioSession.sharedInstance().setActive(true)
           
        }
        catch {
            print(error)
            // report for an error
        }
        
        
        
         MPVolumeView.setVolume(0.5)
    

       // player.play()
        audio_plauyer.play()
 */
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.play_sound()
        })
    //    play_sound()
    }
    
    
    @IBAction func start_monitoring(_ sender: UIButton) {
        start_tasks()
    }
    @IBAction func first_button(_ sender: UIButton) {
      //  call_notif()
    }
    
    var is_true = false
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("appeared")
        
        if (isKeyPresentInUserDefaults(key: "is_first_set"))
        {
            if (UserDefaults.standard.bool(forKey: "is_first_set"))
            {
                UserDefaults.standard.set(false, forKey: "is_first_set")
           performSegue(withIdentifier: "first_to_congo_segue", sender: self)
            }else{
                performSegue(withIdentifier: "first_to_main_segue", sender: self)
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       
        
    
        baby_in_car_check_logo.layer.borderColor = UIColor.blue.cgColor
        baby_in_car_check_logo.layer.borderWidth = 2.5
        baby_in_car_check_logo.layer.cornerRadius = 10.0
        baby_in_car_check_logo.layer.shadowColor = UIColor.black.cgColor
         baby_in_car_check_logo.layer.shadowRadius = 0.4
         baby_in_car_check_logo.layer.shadowOpacity=0.2
       baby_in_car_check_logo.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
        
        
       next_button_rounded.layer.borderColor = UIColor.blue.cgColor
        next_button_rounded.layer.borderWidth = 2.5
      next_button_rounded.layer.cornerRadius = 10.0
        next_button_rounded.layer.shadowColor = UIColor.black.cgColor
        next_button_rounded.layer.shadowRadius = 0.4
        next_button_rounded.layer.shadowOpacity=0.2
        next_button_rounded.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
        
        rotateView(targetView: sunny_view , duration: 10)
        
        
 
        
        
        
        
        
        
        
        
        
        
        
        /*
        
        
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways)
        {
        locationManager.requestAlwaysAuthorization()
        }
        else{
            
          
           // self.region.notifyEntryStateOnDisplay = true
         
          
        
            
          
           
        //    locationManager.startMonitoringVisits()
          
            
            
        }
 */
        
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("I am in")
       // call_notif()
        play_sound()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("I left")
   // call_notif()
       
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error monitoring")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
       
        print("monitoring started")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
      //  print("det state")
        
        // call_notif()
        
        
        /*
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "bla bla"
        content.subtitle = "blew blew"
        content.body = "sjdnfkdsjnknfjkdsnf"
        
        
        let request = UNNotificationRequest(identifier: "custom notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if (error != nil)
            {
               // print("error with notification")
            }
            else{
                //print("Noti done")
            }
        }
 */
        
        
        /*
        
        if (state == .inside)
        {
            print("i am inside by state")
        }
        else{
            print("I ditermined state")
        }
 */
    }
    

    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
       // print(beacons)
        /*
        print("monitored region")
        if (!is_true)
        {
            is_true=true
            print("first time")
             locationManager.startMonitoring(for: region)
        }
 */
        /*
        let knownBeacons = beacons.filter{$0.proximity != CLProximity.unknown}
        if (knownBeacons.count>0)
        {
            let closestBeacon = knownBeacons[0] as CLBeacon
            print(knownBeacons)
        }
 */
 
        
        
        
    }
    
  
    
    func start_tasks()  {
        self.region.notifyOnEntry = true
        self.region.notifyOnExit = true
        //  self.region.notifyEntryStateOnDisplay = true
        //
        locationManager.pausesLocationUpdatesAutomatically=false
        
        if (CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self))
        {
            print("yes available")
            
            // locationManager.startMonitoringSignificantLocationChanges()
            
            
            
            if (locationManager.monitoredRegions.contains(region))
            {
                // locationManager.stopUpdatingLocation()
                //locationManager.stopMonitoringVisits()
                locationManager.stopRangingBeacons(in: region)
                locationManager.stopMonitoring(for: region)
                //     locationManager.stopUpdatingLocation()
                print("already there")
                //  print(<#T##items: Any...##Any#>)
            }
            else{
                //   locationManager.startUpdatingLocation()
                //   locationManager.startMonitoringVisits()
                
                if #available(iOS 9.0, *) {
                    locationManager.allowsBackgroundLocationUpdates=true
                } else {
                   
                }
                //  locationManager.startUpdatingLocation()
                locationManager.startRangingBeacons(in: region)
                locationManager.startMonitoring(for: region)
            }
            
            
            
            //  locationManager.startMonitoring(for: region)
            //locationManager.stopMonitoring(for: region)
        }
        else{
            print("not available")
        }
    }
    
    func play_sound() {
        
        let sound_url = Bundle.main.url(forResource: "alarm_tone", withExtension: "mp3")
        do {
            audio_plauyer = try AVAudioPlayer(contentsOf: sound_url!)
            
            do {
                // try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                
                /*
                 try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
                 try AVAudioSession.sharedInstance().setActive(true)
                 UIApplication.shared.beginReceivingRemoteControlEvents()
                 */
                // Removed deprecated use of AVAudioSessionDelegate protocol
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.duckOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
               // MPVolumeView.setVolume(1)
                print("I started my playing")
                //audio_plauyer.play()
                if audio_plauyer.prepareToPlay() &&
                    audio_plauyer.play(){
                    print("Successfully started playing")
                } else {
                    print("Failed to play")
                }
                //try AVAudioSession.sharedInstance().setActive(true)
                
            }
            catch {
                print("Error from setting session", error)
                // report for an error
            }
            
        }catch{
            print("error from creating audio player")
        }
       
      
        
        
        
        
        
        // player.play()
       //
    }
    
    
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
   

}



