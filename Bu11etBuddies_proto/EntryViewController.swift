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
    

    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - CLLocationManagerDelegate methods

    
    @IBOutlet weak var positionLatLabel: UILabel!
    
    @IBOutlet weak var positionLonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var remainingTime: TimeInterval?
    var timer: Timer?
    
    var positionData: (latitude: Double, longitude: Double)?
    override func viewDidLoad() {
        super.viewDidLoad()


        // CLLocationManagerの設定
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 最も高い精度での位置情報を要求
        locationManager.distanceFilter = kCLDistanceFilterNone // 位置が変わるたびに通知を受け取る
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    @IBAction func dataPicker(_ sender: Any) {
        // カウントダウンの時間を秒単位で取得
        let timeInterval = datePicker.countDownDuration
        
        // 秒を時間、分、秒に変換
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        // 変換された時間を文字列として表示
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    


    
    @IBAction func startButton(_ sender: Any) {
        
        // datePickerからカウントダウンの時間を取得
        remainingTime = datePicker.countDownDuration
        
        // 既存のタイマーがあれば破棄する
        timer?.invalidate()

        // 新しいタイマーを開始する
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if let time = strongSelf.remainingTime, time > 0 {
                strongSelf.remainingTime! -= 1
                
                // 時間、分、秒に変換
                let hours = Int(time) / 3600
                let minutes = (Int(time) % 3600) / 60
                let seconds = Int(time) % 60

                // 残り時間をtimeLabelに設定
                strongSelf.timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                print(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                
    
                // 位置情報を取得
                strongSelf.locationManager.startUpdatingLocation()
                
            } else {
                strongSelf.timer?.invalidate() // タイマーを停止する
                strongSelf.locationManager.stopUpdatingLocation() // 位置情報の取得を停止
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            positionData = (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
    
            // 位置情報をラベルに設定 (小数点以下5桁に制限)
            positionLatLabel.text = String(format: "Latitude: %.5f", location.coordinate.latitude)
            positionLonLabel.text = String(format: "Longitude: %.5f", location.coordinate.longitude)
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
