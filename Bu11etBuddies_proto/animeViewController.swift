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

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 動画終了時の通知を追加
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)

        playLocalVideo()
    }

    func playLocalVideo() {
        if let path = Bundle.main.path(forResource: "銃痕2_smg", ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: path)

            player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            playerViewController.showsPlaybackControls = false

            // タップジェスチャの追加
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            playerViewController.view.addGestureRecognizer(tapGesture)

            // 子ビューコントローラとしてAVPlayerViewControllerを追加
            addChild(playerViewController)
            view.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: self)

            player?.play()
        }
    }

    @objc func playerDidReachEnd(note: NSNotification) {
        player?.seek(to: CMTime.zero)
        player?.play()
    }

    @objc func handleTap() {
        if let openingVC = storyboard?.instantiateViewController(withIdentifier: "OpeningViewControllerID") as? OpeningViewController {
            navigationController?.pushViewController(openingVC, animated: true)
        }
        player?.pause()
    }
}
