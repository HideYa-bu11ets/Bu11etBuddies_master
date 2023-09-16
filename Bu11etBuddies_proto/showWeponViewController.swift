//
//  showWeponViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 沼田英也 on 2023/09/16.
//

import UIKit
import Kingfisher

class ShowWeponViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWeponTableView.delegate = self
        showWeponTableView.dataSource = self
            
        let userDefaults = UserDefaults.standard
        // 中に何かあれば辞書に
        if userDefaults.object(forKey: "add") != nil {
            profileDateDic = userDefaults.object(forKey: "add") as! [String: String]
            print(profileDateDic)
            // これで前入力したものがテキストに表示される
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
                case 1.5..<4.5:
                    rankLabel.text = "MASTER"
                case 1.0..<1.5:
                    rankLabel.text = "DIAMOND"
                case 0.6..<1.0:
                    rankLabel.text = "PLATINA"
                case 0.3..<0.6:
                    rankLabel.text = "GOLD"
                default:
                    rankLabel.text = "SILVER"
                }
            } else {
                rankLabel.text = ""  // 何も表示しない
            }
        }
        // Assuming you've registered the cell in the storyboard
        // If not, register it in code:
        // weponTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cells")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
                if userDefaults.object(forKey: "wepon") != nil {
                    itemCollection = userDefaults.object(forKey: "wepon") as! [String]
                    print("動作確認")
                    print(itemCollection)
                    print("動作確認")
                    showWeponTableView.reloadData()
        }
    }
    @IBAction func deleteWeaponButton(_ sender: Any) {

        
        itemCollection = []
        UserDefaults.standard.set(itemCollection, forKey: "wepon")
        showWeponTableView.reloadData()
        
    }
    
    // MARK: - TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showWeponTableView.dequeueReusableCell(withIdentifier: "SCells", for: indexPath)
        
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
