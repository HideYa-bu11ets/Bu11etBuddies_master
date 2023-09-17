//
//  ProfileDetaViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/17.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class ProfileDetaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var killLabel: UILabel!
    @IBOutlet weak var dethLabel: UILabel!
    @IBOutlet weak var killRatesLabel: UILabel!
    @IBOutlet weak var showWeponTableView: UITableView!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    var itemCollection: [String] = []
    var profileDateDic: [String: String] = [:]
    var tagName: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        showWeponTableView.delegate = self
        showWeponTableView.dataSource = self

        
        guard let searchTagName = tagName else { return }
        
        let ref = Database.database().reference().child("userAllDate")
        ref.queryOrdered(byChild: "profileData/tagName").queryEqual(toValue: searchTagName).observeSingleEvent(of: .value) { snapshot in
            if let userDict = snapshot.value as? [String: Any],
               let firstUserKey = userDict.keys.first,
               let userDetails = userDict[firstUserKey] as? [String: Any] {
                
                if let items = userDetails["items"] as? [String] {
                    self.itemCollection = items
                }
                
                if let profileData = userDetails["profileData"] as? [String: Any] {
                    self.profileDateDic = profileData.mapValues { "\($0)" }
                }
                self.updateUI()
                self.showWeponTableView.reloadData()
            }
            print("ちゅうちゅう確認中")
            print(self.itemCollection)
            print(self.profileDateDic)
        }
    }
    
    func updateUI() {
        
        tagNameLabel.text = profileDateDic["tagName"]
        killLabel.text = profileDateDic["kill"]
        dethLabel.text = profileDateDic["death"]
        teamLabel.text = profileDateDic["team"]
        if let teamName = profileDateDic["team"] {
            switch teamName {
            case "North":
                teamImage.image = UIImage(named: "north")
            case "South":
                teamImage.image = UIImage(named: "south")
            case "East":
                teamImage.image = UIImage(named: "east")
            case "West":
                teamImage.image = UIImage(named: "west")
            default:
                break
            }
        }
        var killRate: Double? = nil

        if let killString = profileDateDic["kill"], let deathString = profileDateDic["death"],
           let kill = Int(killString), let death = Int(deathString), death != 0, kill != 0 {
            killRate = Double(kill) / Double(death)
            killRatesLabel.text = String(format: "%.1f", killRate!)  // 小数点以下2桁まで表示
        } else {
            killRatesLabel.text = ""  // 何も表示しない
        }

        if let rate = killRate {
            switch rate {
            case 4.5...:
                rankLabel.text = "PREDATOR"
                rankLabel.textColor = .black // 黒色
            case 1.5..<4.5:
                rankLabel.text = "MASTER"
                rankLabel.textColor = .purple // 紫色
            case 1.0..<1.5:
                rankLabel.text = "DIAMOND"
                rankLabel.textColor = .cyan // 水色
            case 0.6..<1.0:
                rankLabel.text = "PLATINA"
                rankLabel.textColor = .white // 白色
            case 0.3..<0.6:
                rankLabel.text = "GOLD"
                rankLabel.textColor = .yellow // 金色
            default:
                rankLabel.text = "SILVER"
                rankLabel.textColor = .lightGray // 銀色
            }
        } else {
            rankLabel.text = "BRONZE"
            rankLabel.textColor = UIColor.brown // 茶色
        }
    }


    // MARK: - Navigation
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return itemCollection.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = showWeponTableView.dequeueReusableCell(withIdentifier: "SSCells", for: indexPath)
         
         print("cell情報")
         print(itemCollection[indexPath.row])
         
         if let weponImageView = cell.viewWithTag(1) as? UIImageView {
             let imageUrlString = itemCollection[indexPath.row]
             print(imageUrlString)
             if let imageUrl = URL(string: imageUrlString), !imageUrlString.contains("amazon") {

                 weponImageView.kf.setImage(with: imageUrl)
             } else {
                 weponImageView.image = UIImage(named: "noimage")
             }
         }
         
         return cell
     }
     
     // MARK: - TableView Delegate
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return self.view.frame.height * 2 / 10
         
     }
}
