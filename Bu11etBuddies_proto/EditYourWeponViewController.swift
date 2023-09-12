//
//  EditYourWeponViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

import FirebaseDatabase
import FirebaseStorage
class EditYourWeponViewController: UIViewController {

    @IBOutlet weak var weaponModelText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        downloadCSVFromFirebaseStorage(filePath: "gs://bu11etbuddies.appspot.com/weapons/weapons.csv") { data, error in
            if let error = error {
                print("Error downloading CSV: \(error)")
            } else if let data = data, let csvString = String(data: data, encoding: .utf8) {
                // csvStringを解析して使用する
                let rows = csvString.components(separatedBy: "\n")
                // ...
            }
        }
        
    }
    
 

    func downloadCSVFromFirebaseStorage(filePath: String, completion: @escaping (Data?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let csvRef = storageRef.child(filePath) // filePathは、Firebase Storage上のCSVファイルのパス

        // ファイルをダウンロード
        csvRef.getData(maxSize: 1 * 1024 * 1024) { data, error in // 1MBの制限を設定
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                completion(data, nil)
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
