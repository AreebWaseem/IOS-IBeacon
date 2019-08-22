//
//  homeViewController.swift
//  Baby in car check IOS
//
//  Created by Areeb Waseem on 6/22/18.
//  Copyright © 2018 Areeb Waseem. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import AVFoundation
import MediaPlayer
import QuartzCore
import CoreBluetooth


class homeViewController: UIViewController, CLLocationManagerDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var baby_in_car_top_label: UILabel!
    
    @IBOutlet weak var next_bottom_label: UIButton!
    
    @IBOutlet weak var sinny_view: UIImageView!
    
       var audio_plauyer : AVAudioPlayer!
    
     var manager:CBCentralManager!
    
    let locationManager = CLLocationManager()
    
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("beacons.plist")
    
      var beacon_array = [beacon_item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baby_in_car_top_label.layer.borderColor = UIColor.blue.cgColor
       baby_in_car_top_label.layer.borderWidth = 2.5
        baby_in_car_top_label.layer.cornerRadius = 10.0
       baby_in_car_top_label.layer.shadowColor = UIColor.black.cgColor
        baby_in_car_top_label.layer.shadowRadius = 0.4
       baby_in_car_top_label.layer.shadowOpacity=0.2
        baby_in_car_top_label.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
        
        
        next_bottom_label.layer.borderColor = UIColor.blue.cgColor
        next_bottom_label.layer.borderWidth = 2.5
        next_bottom_label.layer.cornerRadius = 10.0
       next_bottom_label.layer.shadowColor = UIColor.black.cgColor
       next_bottom_label.layer.shadowRadius = 0.4
        next_bottom_label.layer.shadowOpacity=0.2
       next_bottom_label.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        
        
        rotateView(targetView: sinny_view , duration: 10)
        
         manager = CBCentralManager()
        
         locationManager.delegate = self
        
        
        
      
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let selected_uuid = UserDefaults.standard.string(forKey: "selected_region_uuid")
        
        load_items()
        
        
        
        var is_bool = false
        
        for i in beacon_array{
            if (i.beacon_uuid == selected_uuid)
            {
             let region =  CLBeaconRegion(proximityUUID: NSUUID(uuidString: i.beacon_uuid)! as UUID, identifier: i.bacon_name)
                if (locationManager.monitoredRegions.contains(region))
                {
                    is_bool = true
                    next_bottom_label.setTitle("Stop Tracking", for: .normal)
                }
            }
        }
        if (!is_bool)
        {
             next_bottom_label.setTitle("Start Tracking", for: .normal)
        }
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load_items() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do{
                beacon_array = try decoder.decode([beacon_item].self, from: data)
            }catch{
                print ("error decoding")
            }
            
        }
    }

    
   
    @IBAction func start_or_stop_tracking(_ sender: UIButton) {
        

        
        load_items()

        let selected_uuid = UserDefaults.standard.string(forKey: "selected_region_uuid")
        

        

        
        for i in beacon_array{
            if (i.beacon_uuid == selected_uuid)
            {
                start_tasks(beacon_name: i.bacon_name, beacon_uid: i.beacon_uuid)
                break;
            }
        }
    
    
        
        
        
    }
    
    func start_tasks(beacon_name:String,beacon_uid:String)  {
        
        
        let my_var =  NSUUID(uuidString: beacon_uid)
        
        if (my_var != nil)
        {
            
            let region =  CLBeaconRegion(proximityUUID: NSUUID(uuidString: beacon_uid)! as UUID, identifier: beacon_name)
            
            region.notifyOnEntry = true
            region.notifyOnExit = true
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
                    next_bottom_label.setTitle("Sart Tracking", for: .normal)
                }
                else{
                    //   locationManager.startUpdatingLocation()
                    //   locationManager.startMonitoringVisits()
                    
                    if (check_and_request_bluetooth())
                    {
                    locationManager.allowsBackgroundLocationUpdates=true
                    //  locationManager.startUpdatingLocation()
                    locationManager.startRangingBeacons(in: region)
                    locationManager.startMonitoring(for: region)
                    UserDefaults.standard.set(beacon_uid, forKey: "selected_region_uuid")
                    }else{
                            self.show_alert(heading: "Error", body: "Please turn on bluetooth")
                    }
                    
                }
                
                
                
                
                //  locationManager.startMonitoring(for: region)
                //locationManager.stopMonitoring(for: region)
            }
            else{
                show_alert(heading: "Error", body: "Monitoring not available, check phone settings")
                print("not available")
            }
        }else{
            show_alert(heading: "Error", body: "Please create a beacon with a valid beacon UUID")
            print("invalid beacon id")
        }
    }
    
    
    
    
    // MARK: - Notification Method
    
    
    func call_notif()
    {
        
        
        if #available(iOS 10.0, *) {
            //iOS 10 or above version
            
            /*
             let center = UNUserNotificationCenter.current()
             let content = UNMutableNotificationContent()
             content.title = "Late wake up call"
             content.body = "The early bird catches the worm, but the second mouse gets the cheese."
             content.categoryIdentifier = "alarm"
             content.userInfo = ["customData": "fizzbuzz"]
             content.sound = UNNotificationSound.default()
             
             var dateComponents = DateComponents()
             dateComponents.hour = 15
             dateComponents.minute = 49
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
             
             let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
             center.add(request)
             */
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Alert"
            content.subtitle = "Check your baby!"
            
            
            let request = UNNotificationRequest(identifier: "custom notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if (error != nil)
                {
                    print("error with notification")
                }
                else{
                    print("Noti done")
                }
            }
            
            
        } else {
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            notification.alertTitle = "Alert"
            notification.alertBody = "Check your baby!"
            // notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        
        
        
        
    }
    
    func call_notif_connect()
    {
        
        
        if #available(iOS 10.0, *) {
            //iOS 10 or above version
            
            /*
             let center = UNUserNotificationCenter.current()
             let content = UNMutableNotificationContent()
             content.title = "Late wake up call"
             content.body = "The early bird catches the worm, but the second mouse gets the cheese."
             content.categoryIdentifier = "alarm"
             content.userInfo = ["customData": "fizzbuzz"]
             content.sound = UNNotificationSound.default()
             
             var dateComponents = DateComponents()
             dateComponents.hour = 15
             dateComponents.minute = 49
             let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
             
             let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
             center.add(request)
             */
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Alert"
            content.subtitle = "Tracking Started"
            content.sound = UNNotificationSound.default()
            
            
            let request = UNNotificationRequest(identifier: "custom notification", content: content, trigger: trigger)
            
            
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if (error != nil)
                {
                    print("error with notification")
                }
                else{
                    print("Noti done")
                }
            }
            
            
        } else {
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            notification.alertTitle = "Alert"
            notification.alertBody = "Tracking Started"
            // notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        
    }
    
    
    
    
    
    
    
    // MARK: - Enter exit methods
    /*
    
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
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("I am in")
        
        
        var seconds:Double = NSDate().timeIntervalSince1970
        
        seconds = seconds * 1000
        
        let timestamp = seconds.rounded()
        
        
        UserDefaults.standard.set(timestamp, forKey: "last_connection_time")
        UserDefaults.standard.set(true, forKey: "once_connected")
        
        
          call_notif_connect()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("I left")
        
        if (isKeyPresentInUserDefaults(key: "once_connected"))
        {
            if (UserDefaults.standard.bool(forKey: "once_connected"))
            {
                UserDefaults.standard.set(false, forKey: "once_connected")
                if (isKeyPresentInUserDefaults(key: "last_connection_time"))
                {
                    let timestamp = UserDefaults.standard.double(forKey: "last_connection_time")
                    
                    var seconds:Double = NSDate().timeIntervalSince1970
                    
                    seconds = seconds * 1000
                    
                    let current_time = seconds.rounded()
                    
                    if ((current_time-timestamp)>(0.5*60*1000))
                    {
                        play_sound()
                        call_notif()
                    }else{
                        print ("not 5 min")
                        // not 5 min time
                    }
                    
                }
                else{
                    call_notif()
                    play_sound()
                }
            }
            else{
                print ("no enter made")
            }
        }
        else{
               print("not once connnected")
        }
        
    }
    
    */
    
    
    // MARK: - Tracking started or not
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error monitoring")
        show_alert(heading: "Error", body: "Please check your phone and permission settings")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitoring started")
        //  performSegue(withIdentifier: "test_mani_segue", sender: ViewController.self)
     
        next_bottom_label.setTitle("Stop Tracking", for: .normal)
    }
    
    
    /*
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
 
 */
    // MARK: - Audio finished playing
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("i finished playing :)")
        /*
         if (isKeyPresentInUserDefaults(key: "user_volume"))
         {
         let volume = UserDefaults.standard.float(forKey: "user_volume")
         MPVolumeView.setVolume(volume)
         }
         else{
         MPVolumeView.setVolume(0.5)
         }
         */
    }
    
    // MARK: - Play Sound
    
    func play_sound() {
        
        let sound_url = Bundle.main.url(forResource: "alarm_tone", withExtension: "mp3")
        do {
            audio_plauyer = try AVAudioPlayer(contentsOf: sound_url!)
            audio_plauyer.delegate = self
            
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
                
                let volume = AVAudioSession.sharedInstance().outputVolume
                print(volume)
                UserDefaults.standard.set(volume, forKey: "user_volume")
                
                
                if (isKeyPresentInUserDefaults(key: "slider_set_volume"))
                {
                    let slid_volume = UserDefaults.standard.float(forKey: "slider_set_volume")
                    MPVolumeView.setVolume(slid_volume)
                }else{
                    MPVolumeView.setVolume(1)
                }
                
                
                print("I started my playing")
                //audio_plauyer.play()
                var audio_time:Float = 5.0;
                if (isKeyPresentInUserDefaults(key: "slider_set_time"))
                {
                    let time_inter = UserDefaults.standard.float(forKey: "slider_set_time")
                    audio_time = time_inter * 10;
                }
                
                
                  _ = Timer.scheduledTimer(timeInterval: TimeInterval(audio_time), target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
                
                
                
                
                /*
                _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(audio_time), repeats: false) { timer in
                    self.audio_plauyer.stop()
                    if (self.isKeyPresentInUserDefaults(key: "user_volume"))
                    {
                        let volume = UserDefaults.standard.float(forKey: "user_volume")
                        MPVolumeView.setVolume(volume)
                    }
                    else{
                        MPVolumeView.setVolume(0.5)
                    }
                    
                }
 
 */
                
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
    
    
    func show_alert(heading:String, body:String)
    {
        let alert = UIAlertController(title: heading, message: body, preferredStyle: .alert)
        let dismiss_action = UIAlertAction(title: "Dismiss", style: .default) { (dismiss_action) in
            print("dismissed")
        }
        alert.addAction(dismiss_action)
        present(alert, animated : true, completion : nil)
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    
    func check_and_request_bluetooth() -> Bool {
        if (manager.state == .poweredOff)
        {
            return false
        }
        else{
            return true
        }
    }
    
  
    
    @objc func update()
    {
        self.audio_plauyer.stop()
        if (self.isKeyPresentInUserDefaults(key: "user_volume"))
        {
            let volume = UserDefaults.standard.float(forKey: "user_volume")
            MPVolumeView.setVolume(volume)
        }
        else{
            MPVolumeView.setVolume(0.5)
        }
    }
    

    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
