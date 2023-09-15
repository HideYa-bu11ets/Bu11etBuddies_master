//
//  OpeningViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import Firebase
import AVFoundation

class OpeningViewController: UIViewController {

    @IBOutlet weak var logInIdTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSound()

        // Do any additional setup after loading the view.
    }
    
    //どこかタップするとキーボードが降りる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        logInIdTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
    }
    
    @IBAction func logInButton(_ sender: Any) {
        //匿名ログインクロージャー
        Auth.auth().signInAnonymously{(authResult,error) in
            let user = authResult?.user
            print(user)
        }
    }
    @IBAction func addNewMenberButton(_ sender: Any) {
    }
    
    func setupSound() {
        if let sound = Bundle.main.path(forResource: "Come_On", ofType: "mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
            resultAudioPlayer.play()
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
