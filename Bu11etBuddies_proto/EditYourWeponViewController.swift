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
        print("ボタンが押されました。")
        downloadCSVFromFirebaseStorage(filePath: "weapons/weapon.csv") { data, error in
            if let error = error {
                print("Error downloading CSV: \(error)")
            } else if let data = data, let csvString = String(data: data, encoding: .utf8) {
                // csvStringを解析して使用する
                let rows = csvString.components(separatedBy: "\n")
                
                // 各行を","で分割して配列に格納
                let csvData: [[String]] = rows.compactMap { row in
                    let elements = row.components(separatedBy: ",")
                    if elements.count > 0 {
                        return elements
                    } else {
                        return nil
                    }
                }
                
                print(csvData[1])
            }
        }
        
    }
    
 

    func downloadCSVFromFirebaseStorage(filePath: String, completion: @escaping (Data?, Error?) -> Void) {
        print("関数が呼ばれました。")
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://bu11etbuddies.appspot.com/")
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
