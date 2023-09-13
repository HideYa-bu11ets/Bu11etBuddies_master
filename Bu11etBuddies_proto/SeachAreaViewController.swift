//
//  SeachAreaViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Kingfisher
import Foundation

class SeachAreaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var searchAreaTextField: UITextField!
    @IBOutlet weak var areaTableView: UITableView!
    var searchAreaCells : [[String: String]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        areaTableView.delegate = self
        areaTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        guard let keyword = searchAreaTextField.text, !keyword.isEmpty else {
            print("キーワードを入力してください。")
            return
        }
        
        print("ボタンが押されました。")
        downloadCSVFromFirebaseStorage(filePath: "shop/area.csv") { data, error in
            if let error = error {
                print("Error downloading CSV: \(error)")
            } else if let data = data, let csvString = String(data: data, encoding: .utf8) {
                //print(csvString)
                
                /*
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
                */
                // ヘッダーを取得
                let header = "Unnamed: 0\t一般バス\t18歳未満\t市街戦\texplain_shop\t最寄駅\t住所\tペイントボール\t森林\ttwitter\tシャワー完備\tinstagram\tURL\tイベント名\tYoutube\t無料送迎\t駐車場\t装備レンタル\t更衣室\t最寄IC\t開催日\t貸切キャンセル\tエリア\tナイトゲーム\t最寄駅～フィールドまでの距離\t屋外\t定例会料金・利用料金\timg_list\tfacebook\t貸切料金\tインドア\t適正人数"

                let columns = header.components(separatedBy: "\t")
                let numberOfColumns = columns.count

                // csvStringをカラム数を元に解析
                var rows = [[String]]()
                var currentRow = [String]()
                var currentCell = ""
                var isInQuote = false
                
                for char in csvString {
                    switch char {
                    case "\"":
                        currentCell.append(char)
                        isInQuote.toggle()
                    case ",":
                        if isInQuote {
                            currentCell.append(char)
                        } else {
                            currentRow.append(currentCell)
                            currentCell = ""
                        }
                    case "\n":
                        if isInQuote {
                            currentCell.append(char)
                        } else {
                            currentRow.append(currentCell)
                            if currentRow.count == numberOfColumns {
                                rows.append(currentRow)
                            }
                            currentRow = []
                            currentCell = ""
                        }
                    default:
                        currentCell.append(char)
                    }
                }
                if !currentCell.isEmpty {
                    currentRow.append(currentCell)
                }
                if !currentRow.isEmpty && currentRow.count == numberOfColumns {
                    rows.append(currentRow)
                }
                
                print(rows)

                let matchedDictionaries = self.searchAndStoreRows(containing: keyword, in: rows)

                self.searchAreaCells = matchedDictionaries
                self.areaTableView.reloadData()
                //print(matchedDictionaries[0])
                //print(matchedDictionaries)
            
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
        
        
        let areaIndex = headerRow.firstIndex(of: "エリア")

        let postalIndex = headerRow.firstIndex(of: "住所")

    

        var matchedDictionaries: [[String: String]] = []
        
        for row in csvData.dropFirst() {
          
            var isMatched = false

            if let areaIdx = areaIndex, row.indices.contains(areaIdx), row[areaIdx].contains(keyword) {
                print(row[areaIdx])
                isMatched = true
            }

            if let postalIdx = postalIndex, row.indices.contains(postalIdx), row[postalIdx].contains(keyword) {
                print(row[postalIdx])
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
    
    // MARK: - Cell
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAreaCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(searchAreaCells[indexPath.row])
        
        let cell = areaTableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath)
        
        //        店舗名
        let storeNameLabel = cell.viewWithTag(1) as! UILabel
        storeNameLabel.text = searchAreaCells[indexPath.row]["エリア"]
        
        //        店舗画像
        
   
        var array = searchAreaCells[indexPath.row]["img_list"]?.components(separatedBy: "、")
        
        var img_list :[String] = []
        for var str in array!{
            str.removeAll(where: { $0 == "'" })
            str.removeAll(where: { $0 == "[" })
            str.removeAll(where: { $0 == "]" })
            str.removeAll(where: { $0 == " " })
            str.removeAll(where: { $0 == "　" })
            
            if img_list.contains(str) {
      
            }
            else{
                img_list.append(str)
            }
        }
        print(img_list)
        
        var count = 1
        for var imageUrlString in img_list{
            count+=1
            
            var storeImageView = cell.viewWithTag(count) as! UIImageView

            let imageUrl = URL(string: imageUrlString)

            storeImageView.kf.setImage(with: imageUrl)

        }
        count = 1
        if img_list.count == 1{
            var img_list :[String] = ["",""]
            for var imageUrlString in img_list{
                count+=1
                
                var storeImageView = cell.viewWithTag(count) as! UIImageView

                storeImageView.image = UIImage(named: "noimage")

            }
        
        }

        /*
        let storeImageView = cell.viewWithTag(2) as! UIImageView
        if let imageUrlString = searchAreaCells[indexPath.row]["img_list"],
           let imageUrl = URL(string: imageUrlString),
           !imageUrlString.contains("amazon") {
            storeImageView.kf.setImage(with: imageUrl)
        } else {
            storeImageView.image = UIImage(named: "noimage")
        }
         */
        
        
        //        住所
        let addressLabel = cell.viewWithTag(4) as! UILabel
        addressLabel.text = searchAreaCells[indexPath.row]["住所"]
        
        
        //        料金
        let feeLabel = cell.viewWithTag(5) as! UILabel
        feeLabel.text = searchAreaCells[indexPath.row]["定例会料金・利用料金"]
        
        return cell
    }
    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 3
    }
    
    
}

