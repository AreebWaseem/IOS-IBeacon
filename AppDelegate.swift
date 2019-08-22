//
//  AppDelegate.swift
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
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    
    var locationManager:CLLocationManager!
    
    var audio_plauyer : AVAudioPlayer!
    
    
    var manager:CBCentralManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate=self
        }
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.blue
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
         manager = CBCentralManager()
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
            
            
            let request = UNNotificationRequest(identifier: "disconnect_notification", content: content, trigger: trigger)
            
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
            content.sound =  UNNotificationSound.default()
            
            let request = UNNotificationRequest(identifier: "connect_notification", content: content, trigger: trigger)
            
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
             notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        
    }
    
    
    
    // MARK: - Enter exit methods
    
    
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
                        print("from greater 5")
                        play_sound()
                        call_notif()
                    }else{
                        print ("not 5 min")
                        // not 5 min time
                    }
                    
                }
                else{
                    print("from lesser 5")
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
    
    
    
    
    // MARK: - Tracking started or not
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error monitoring")
       // show_alert(heading: "Error", body: "Please check your phone and permission settings")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitoring started")
        //  performSegue(withIdentifier: "test_mani_segue", sender: ViewController.self)
       // UserDefaults.standard.set(true, forKey: "is_first_set")
       // self.dismiss(animated: true)
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
                if #available(iOS 10.0, *) {
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
                } else {
                    // Fallback on earlier versions
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
    
    
    
    
    
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    
    
    /*
    func show_alert(heading:String, body:String)
    {
        let alert = UIAlertController(title: heading, message: body, preferredStyle: .alert)
        let dismiss_action = UIAlertAction(title: "Dismiss", style: .default) { (dismiss_action) in
            print("dismissed")
        }
        alert.addAction(dismiss_action)
        present(alert, animated : true, completion : nil)
    }
 
 */
    
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
    
    
    
    
    
    
    
    
    
    


}
extension AppDelegate: UNUserNotificationCenterDelegate{
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}

