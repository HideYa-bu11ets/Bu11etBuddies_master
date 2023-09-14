//
//  EntryViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import CoreLocation

class EntryViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()


    // MARK: - CLLocationManagerDelegate methods

    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // CLLocationManagerの設定
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func dataPicker(_ sender: Any) {
        
    }
    


    
    @IBAction func startButton(_ sender: Any) {
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
