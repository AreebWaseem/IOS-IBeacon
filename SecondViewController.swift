//
//  SecondViewController.swift
//  Baby in car check IOS
//
//  Created by Areeb Waseem on 6/13/18.
//  Copyright © 2018 Areeb Waseem. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import AVFoundation
import MediaPlayer
import QuartzCore
import CoreBluetooth

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, AVAudioPlayerDelegate {
    
    var beacon_array = [beacon_item]()
    
    
    @IBOutlet weak var outline_view: UIView!
    
    
    @IBOutlet weak var beacon_table_view: UITableView!
    
    
    let locationManager = CLLocationManager()
    
    var audio_plauyer : AVAudioPlayer!
    
    
    var manager:CBCentralManager!
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("beacons.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beacon_table_view.delegate = self
        beacon_table_view.dataSource = self
        locationManager.delegate = self
        
        
        
        outline_view.layer.borderColor = UIColor.blue.cgColor
        outline_view.layer.borderWidth = 2.0
       outline_view.layer.cornerRadius = 8.0
       outline_view.layer.shadowColor = UIColor.black.cgColor
        outline_view.layer.shadowRadius = 0.4
      outline_view.layer.shadowOpacity=0.1
        outline_view.layer.shadowOffset = CGSize(width: 0.4, height: 1.0)
        
        
        manager = CBCentralManager()
        
        
        
       
        request_loc_auth()
        request_noti_permission()
        
    
        load_items()
        
        
   
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    

    
    
    @IBAction func add_new_beacon(_ sender: UIBarButtonItem) {
        
        
        var beacon_name_field = UITextField()
        var beacon_uuid_field = UITextField()
        
        
        let alert = UIAlertController(title: "Enter Beacon Details", message: "", preferredStyle: .alert)
        let dismiss_action = UIAlertAction(title: "Cancel", style: .default) { (dismiss_action) in
            print("dismissed")
        }
        
        let action = UIAlertAction(title: "Add Beacon", style: .default) { (action) in
            
            
            
            if (!((beacon_name_field.text?.isEmpty)!) && !((beacon_uuid_field.text?.isEmpty)!) )
            {
                
                
                print("Success")
                
         
                
                
                
                let item = beacon_item()
                
                var beacon_name_from_field:String = beacon_name_field.text!
                var beacon_uuid_form_field:String = beacon_uuid_field.text!
                
                beacon_name_from_field = beacon_name_from_field.trimmingCharacters(in: .whitespacesAndNewlines)
                beacon_uuid_form_field = beacon_uuid_form_field.trimmingCharacters(in: .whitespacesAndNewlines)
                
                
                
                item.bacon_name = beacon_name_from_field
                item.beacon_uuid = beacon_uuid_form_field
                
                var is_found = false;
                
                for i in self.beacon_array{
                    if (i.beacon_uuid == item.beacon_uuid)
                    {
                        is_found=true
                    }
                }
                if (!is_found)
                {
                    
                    self.beacon_array.append(item)
                    self.save_items()
                    
                }else{
                    self.show_alert(heading: "Error", body: "Beacon with same UUID already present")
                }
              
                
            }
            else{
                self.show_alert(heading: "Error", body: "Please enter a valid beacon name and uuid")
                print("no data")
            }
            
            
        }
        
        alert.addTextField { (name_text_field) in
            name_text_field.placeholder = "Beacon Name"
            beacon_name_field = name_text_field
        }
        alert.addTextField { (uuid_text_field) in
            uuid_text_field.placeholder = "UUID:00000000-0000-0000-0000-000000000000"
            beacon_uuid_field = uuid_text_field
        }
        
        
        alert.addAction(dismiss_action)
        alert.addAction(action)
        present(alert,animated:true,completion:nil)
       
        
    }
    
    
    // MARK: - Datasource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beacon_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beacon_cell", for:indexPath)
        cell.textLabel?.text = beacon_array[indexPath.row].bacon_name
        
        
        let view = UIView()
        view.backgroundColor = hexStringToUIColor(hex: "#ff4081")
        cell.selectedBackgroundView = view
        cell.textLabel?.highlightedTextColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: beacon_array[indexPath.row].bacon_name, message: "UUID:" + beacon_array[indexPath.row].beacon_uuid, preferredStyle: .alert)
        let dismiss_action = UIAlertAction(title: "Cancel", style: .default) { (dismiss_action) in
            print("dismissed")
        }
 
        let track_action = UIAlertAction(title: "Start Tracking", style: .default) { (track_action) in
            print("start tracking clicked")
            
            
            
            
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.getNotificationSettings { (settings) in
                    if settings.authorizationStatus != .authorized {
                        self.request_noti_permission()
                        self.show_alert(heading: "Error", body: "Notifications permissions are necessary, please check phone settings")
                    }
                    else{
                        if ((CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways))
                        {
                            
                            print(self.beacon_array[indexPath.row].bacon_name)
                            print(self.beacon_array[indexPath.row].beacon_uuid)
                            
                            if (self.check_and_request_bluetooth())
                            {
                                
                                
                                self.start_tasks(beacon_name:self.beacon_array[indexPath.row].bacon_name,beacon_uid:self.beacon_array[indexPath.row].beacon_uuid)
                                
                            }else{
                                self.show_alert(heading: "Error", body: "Please turn on bluetooth")
                            }
                        }
                        else{
                            self.show_alert(heading: "Error", body: "Always location authorization is necessary!")
                            self.request_loc_auth()
                        }
                    }
                }

            }
            else {
                
                if let settings = UIApplication.shared.currentUserNotificationSettings {
                    if (settings.types.contains([.alert, .sound]) || settings.types.contains(.alert)) {
                        if ((CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways))
                        {
                            
                            print(self.beacon_array[indexPath.row].bacon_name)
                            print(self.beacon_array[indexPath.row].beacon_uuid)
                            
                            if (self.check_and_request_bluetooth())
                            {
 
                                self.start_tasks(beacon_name:self.beacon_array[indexPath.row].bacon_name,beacon_uid:self.beacon_array[indexPath.row].beacon_uuid)
                                
                            }else{
                                self.show_alert(heading: "Error", body: "Please turn on bluetooth")
                            }
                        }
                        else{
                            self.show_alert(heading: "Error", body: "Always location authorization is necessary!")
                            self.request_loc_auth()
                        }
                    }
                    else{
                         self.show_alert(heading: "Error", body: "Notifications permissions are necessary, please check phone settings")
                       self.request_noti_permission()
                    }
                }
                else{
                     self.show_alert(heading: "Error", body: "Notifications permissions are necessary, please check phone settings")
                    self.request_noti_permission()
                }
            
            }
            
        }
        alert.addAction(dismiss_action)
        alert.addAction(track_action)
       present(alert,animated : true, completion : nil)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func request_loc_auth() {
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways)
        {
            locationManager.requestAlwaysAuthorization()
               print("started")
        }
        else{
            print("authorized")
        }
    }
    
    func request_noti_permission()
    {
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
                if (error != nil)
                {
                    print("unsuccess")
                }
                else{
                    print(success)
                }
            }
        } else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        
    }
    
    
    func save_items()
    {
        let encoder = PropertyListEncoder()
        do
        {
            let data = try encoder.encode(self.beacon_array)
            try data.write(to: self.dataFilePath!)
            self.beacon_table_view.reloadData()
        }catch{
            print("error saving")
            beacon_array.removeLast()
            // This error needs to be addressed
        }
    }
    
    func load_items() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do{
            beacon_array = try decoder.decode([beacon_item].self, from: data)
                beacon_table_view.reloadData()
            }catch{
                print ("error decoding")
            }
            
        }
    }
    
    
    //MARK: - Beacon tracking methods and delegates
    
  
    
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
                UserDefaults.standard.set(beacon_uid, forKey: "selected_region_uuid")
                UserDefaults.standard.set(true, forKey: "is_first_set")
                self.dismiss(animated: true)
            }
            else{
                //   locationManager.startUpdatingLocation()
                //   locationManager.startMonitoringVisits()
                
                    locationManager.allowsBackgroundLocationUpdates=true
                //  locationManager.startUpdatingLocation()
                locationManager.startRangingBeacons(in: region)
                locationManager.startMonitoring(for: region)
                UserDefaults.standard.set(beacon_uid, forKey: "selected_region_uuid")
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
    
    
    
    
    // MARK: - Tracking started or not
    
    */
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error monitoring")
        show_alert(heading: "Error", body: "Please check your phone and permission settings")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitoring started")
      //  performSegue(withIdentifier: "test_mani_segue", sender: ViewController.self)
        UserDefaults.standard.set(true, forKey: "is_first_set")
     self.dismiss(animated: true)
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
    
    
    
    
    
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
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
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            slider?.value = volume;
        }
    }
}

