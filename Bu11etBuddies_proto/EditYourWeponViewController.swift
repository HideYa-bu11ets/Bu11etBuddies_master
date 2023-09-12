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
        guard let keyword = weaponModelText.text, !keyword.isEmpty else {
            print("キーワードを入力してください。")
            return
        }
        
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
                        //print(elements)
                        return elements
                    } else {
                        //print("fuck")
                        return nil
                    }
                    
                }
                //print(csvData)
                let matchedDictionaries = self.searchAndStoreRows(containing: keyword, in: csvData)
                print(matchedDictionaries.count)
                


                

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
    
    func searchAndStoreRows(containing keyword: String, in csvData: [[String]]) -> [[String: String]] {
        guard let headerRow = csvData.first else {
            print("CSVデータが空です。")
            return []
        }
        
        let tasteIndex = headerRow.firstIndex(of: "Taste")
        let descriptionIndex = headerRow.firstIndex(of: "Description")
        let makerIndex = headerRow.firstIndex(of: "メーカー")
        

        var matchedDictionaries: [[String: String]] = []
        
        for row in csvData.dropFirst() {
            var matchingDict: [String: String] = [:]

            if let tasteIdx = tasteIndex, row.indices.contains(tasteIdx), row[tasteIdx].contains(keyword) {
                matchingDict[headerRow[tasteIdx]] = row[tasteIdx]
            }
            
            if let descIdx = descriptionIndex, row.indices.contains(descIdx), row[descIdx].contains(keyword) {
                matchingDict[headerRow[descIdx]] = row[descIdx]
            }
            
            if let makerIdx = makerIndex, row.indices.contains(makerIdx), row[makerIdx].contains(keyword) {
                matchingDict[headerRow[makerIdx]] = row[makerIdx]
            }
            
            if !matchingDict.isEmpty {
                matchedDictionaries.append(matchingDict)
            }
        }

        return matchedDictionaries
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
