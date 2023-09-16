//
//  EntryViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import CoreLocation
import MapKit
import AVFoundation


// 新しく追加した Codable に準拠する struct
struct Position: Codable {
    var latitude: Double
    var longitude: Double
}

struct LocationTimeData: Codable {
    var time: String
    var position: Position
}

class EntryViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - CLLocationManagerDelegate methods

    
    @IBOutlet weak var positionLatLabel: UILabel!
    
    @IBOutlet weak var positionLonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var locationTimeData: [LocationTimeData] = []
    var remainingTime: TimeInterval?
    var timer: Timer?
    var currentLocation: Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locationTimeData)
        mapView.delegate = self  // この行を追加

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        loadLocationData()
    }
    
    @IBAction func dataPicker(_ sender: Any) {
        let timeInterval = datePicker.countDownDuration
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    

    @IBAction func hitButton(_ sender: Any) {
        setupSound()
        //タイマーを無効にする
        timer?.invalidate()

        // 位置情報の更新を停止する
        locationManager.stopUpdatingLocation()

        // locationTimeDataを出力
        print(locationTimeData)

        // 位置情報をプロットする
        plotLocations()
    }
    
    
    @IBAction func startButton(_ sender: Any) {
        locationTimeData = []
        saveLocationData()
        loadLocationData()
        plotLocations()
        
        print("確認")
        print(locationTimeData)
        print("確認")
        
        remainingTime = datePicker.countDownDuration
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if let time = strongSelf.remainingTime, time > 0 {
                strongSelf.remainingTime! -= 1
                let hours = Int(time) / 3600
                let minutes = (Int(time) % 3600) / 60
                let seconds = Int(time) % 60
                strongSelf.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                
                let locationToUse = strongSelf.currentLocation ?? Position(latitude: 0.0, longitude: 0.0)
                let newEntry = LocationTimeData(time: strongSelf.timeLabel.text ?? "", position: locationToUse)
                strongSelf.locationTimeData.append(newEntry)
                
                strongSelf.saveLocationData()
           
                
            } else {
                strongSelf.timer?.invalidate()
                strongSelf.locationManager.stopUpdatingLocation()
                print(strongSelf.locationTimeData)
                
                // ここでプロット機能を実行
                strongSelf.plotLocations()
            }
        }
    }
    
    func plotLocations() {
        // ここでstrongSelf.locationTimeDataを使って位置情報をプロットする
        for (index, data) in locationTimeData.enumerated() {
            let coordinate = CLLocationCoordinate2D(latitude: data.position.latitude, longitude: data.position.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = "Time \(index + 1)"
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            // もし複数の地点をプロットして、それらの間に線を描画したい場合
            if index > 0 {
                let previousData = locationTimeData[index - 1]
                let previousCoordinate = CLLocationCoordinate2D(latitude: previousData.position.latitude, longitude: previousData.position.longitude)
                let coordinates = [previousCoordinate, coordinate]
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                mapView.addOverlay(polyline)
            }
        }

        // 最後のアノテーションにズームする
        if let lastLocation = locationTimeData.last {
            let lastCoordinate = CLLocationCoordinate2D(latitude: lastLocation.position.latitude, longitude: lastLocation.position.longitude)
            let region = MKCoordinateRegion(center: lastCoordinate, latitudinalMeters: 500, longitudinalMeters: 500) // 500m x 500m の範囲にズーム
            mapView.setRegion(region, animated: true)
        }
    }

    // MKMapViewDelegateメソッドを追加して、ポリラインを地図上に表示するための設定を行う
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = Position(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            positionLatLabel.text = String(format: "Latitude: %.5f", location.coordinate.latitude)
            positionLonLabel.text = String(format: "Longitude: %.5f", location.coordinate.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    func saveLocationData() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(locationTimeData)
            UserDefaults.standard.set(data, forKey: "locationTimeData")
        } catch {
            print("Error encoding locationTimeData: \(error)")
        }
    }

    func loadLocationData() {
        if let savedData = UserDefaults.standard.data(forKey: "locationTimeData") {
            do {
                let decoder = JSONDecoder()
                locationTimeData = try decoder.decode([LocationTimeData].self, from: savedData)
            } catch {
                print("Error decoding locationTimeData: \(error)")
            }
        }
    }
    func setupSound() {
        if let sound = Bundle.main.path(forResource: "狙撃銃発射", ofType: "mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
            resultAudioPlayer.play()
        }
    }
}

