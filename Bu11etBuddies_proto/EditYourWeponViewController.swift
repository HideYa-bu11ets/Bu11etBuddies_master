//
//  EditYourWeponViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class EditYourWeponViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var matchedWeponCells : [[String: String]] = []
    @IBOutlet weak var weaponModelText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        /* self追加 */
        weponTableView.delegate = self
        weponTableView.dataSource = self
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

                self.matchedWeponCells = matchedDictionaries
                self.weponTableView.reloadData()
                print(matchedDictionaries.count)
                //print(matchedDictionaries)
                
                


                

            }
            
        }
    }
    
  
    @IBOutlet weak var weponTableView: UITableView!
    

    

 

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
            var isMatched = false

            if let tasteIdx = tasteIndex, row.indices.contains(tasteIdx), row[tasteIdx].contains(keyword) {
                isMatched = true
            }

            if let descIdx = descriptionIndex, row.indices.contains(descIdx), row[descIdx].contains(keyword) {
                isMatched = true
            }

            if let makerIdx = makerIndex, row.indices.contains(makerIdx), row[makerIdx].contains(keyword) {
                isMatched = true
            }

            if isMatched {
                var matchingDict: [String: String] = [:]
                for (index, value) in row.enumerated() {
                    if index < headerRow.count { // headerRowとrowの要素数が異なる場合を考慮
                        matchingDict[headerRow[index]] = value
                    }
                }
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedWeponCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = weponTableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath)
        print("cell情報")
        print(matchedWeponCells[indexPath.row]["Taste"])
        //        武器名
        let weponNameLabel = cell.viewWithTag(1) as! UILabel
        weponNameLabel.text = matchedWeponCells[indexPath.row]["Taste"]
 
        //        武器ID
        let weponIdLabel = cell.viewWithTag(2) as! UILabel
        weponIdLabel.text = matchedWeponCells[indexPath.row]["Item"]

        
        //        メーカー名
        let makerLabel = cell.viewWithTag(3) as! UILabel
        makerLabel.text = matchedWeponCells[indexPath.row]["メーカー"]

        
        //        武器画像
        let weponImageView = cell.viewWithTag(4) as! UIImageView
        if let imageUrlString = matchedWeponCells[indexPath.row]["Image URL"],
           let imageUrl = URL(string: imageUrlString) {
            weponImageView.kf.setImage(with: imageUrl)
        } else {
            
        }
        
        return cell
    }
    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 3
    }
    

}

