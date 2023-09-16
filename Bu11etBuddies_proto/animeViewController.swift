//
//  animeViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/15.
//

import UIKit
import AVKit
import AVFoundation

class animeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        playLocalVideo()
        print("表示")

        // Do any additional setup after loading the view.
    }
    
    var playerLooper: AVPlayerLooper?
    let player = AVQueuePlayer()

    func playLocalVideo() {
        if let path = Bundle.main.path(forResource: "銃痕2_smg", ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: path)
            let playerItem = AVPlayerItem(url: videoURL)
            
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            // コントロールバーを非表示にする
            playerViewController.showsPlaybackControls = false

            present(playerViewController, animated: true) {
                playerViewController.player?.play()
            }
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
