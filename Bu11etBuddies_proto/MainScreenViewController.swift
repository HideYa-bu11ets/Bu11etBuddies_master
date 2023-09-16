//
//  MainScreenViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import AVFoundation
import CoreLocation


class MainScreenViewController: UIViewController , CLLocationManagerDelegate{
    var locationManager: CLLocationManager!
    


    @IBOutlet weak var areaName: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    var itemCollection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        //中に何かあれば辞書に
        if userDefaults.object(forKey: "area") != nil {
            if userDefaults.object(forKey: "area") != nil {
                itemCollection = userDefaults.object(forKey: "area") as!
                String
                
                areaName.setTitle(itemCollection, for: .normal)
            }
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        //中に何かあれば辞書に
        if userDefaults.object(forKey: "area") != nil {
            if userDefaults.object(forKey: "area") != nil {
                itemCollection = userDefaults.object(forKey: "area") as!
                String
                
                areaName.setTitle(itemCollection, for: .normal)
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
    }
    
    @IBAction func inAreaButton(_ sender: Any) {
    }
    
    @IBAction func entryButton(_ sender: Any) {
        setupSound()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // ここでlocationの緯度経度を取得し、それを使用して都道府県を特定することができます
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Geocode failed: \(error)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let administrativeArea = placemark.administrativeArea, placemark.country == "Japan" {
                        // 日本の場合
                        //self.areaName.setTitle(administrativeArea, for: .normal)
                        print(administrativeArea)
                        UserDefaults.standard.set(administrativeArea, forKey: "administrativeArea")

                    } else if let country = placemark.country {
                        UserDefaults.standard.set(country, forKey: "administrativeArea")

                        // 日本以外の国の場合
                        //self.areaName.setTitle(country, for: .normal)
                        print(country)
                    }
                }
            }
        }
    }

    func setupSound() {
        if let sound = Bundle.main.path(forResource: "ショットガン発射", ofType: "mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
            resultAudioPlayer.play()
        }
    }

}
