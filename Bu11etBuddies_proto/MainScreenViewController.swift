//
//  MainScreenViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import AVFoundation

class MainScreenViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    func setupSound() {
        if let sound = Bundle.main.path(forResource: "ショットガン発射", ofType: "mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
            resultAudioPlayer.play()
        }
    }

}
