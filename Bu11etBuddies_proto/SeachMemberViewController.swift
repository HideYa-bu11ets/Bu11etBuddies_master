//
//  SeachMemberViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import Firebase
import FirebaseDatabase


class SeachMemberViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var seachMemberTableView: UITableView!
    @IBOutlet weak var seachMemberTextField: UITextField!
    var seachMemberCells: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seachMemberTableView.delegate = self
        seachMemberTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileDetail",
           let destVC = segue.destination as? ProfileDetaViewController,
           let tagName = sender as? String {
            destVC.tagName = tagName
        }
    }
    
    @objc func showProfileButtonTapped(_ sender: UIButton) {
        let tagName = seachMemberCells[sender.tag]
        performSegue(withIdentifier: "toProfileDetail", sender: tagName)
    }

    
    @IBAction func seachButton(_ sender: Any) {

        guard let seachTagName = seachMemberTextField.text, !seachTagName.isEmpty else {
                // もしテキストフィールドが空の場合、処理を中断
                return
            }
            print(seachTagName)
        
        let ref = Database.database().reference().child("userAllDate")

        ref.observeSingleEvent(of: .value, with: { snapshot in
            // すべてのデータを取得
            if let allDataDictionary = snapshot.value as? [String: Any] {
                for (key, value) in allDataDictionary {
                    if let userDictionary = value as? [String: Any],
                       let profileData = userDictionary["profileData"] as? [String: Any],
                       let tagName = profileData["tagName"] as? String,
                       tagName == seachTagName {
                        print("Found matching tagName: \(tagName)")
                        self.seachMemberCells = [tagName]
                        self.seachMemberTableView.reloadData()
                        break // 一致したデータを見つけたらループを終了する
                    }
                }
            } else {
                print("Failed to cast snapshot to dictionary.")
            }
        }) { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    

        
            


    }
    
    @IBAction func showProfileButton(_ sender: UIButton) {
        let tagName = seachMemberCells[sender.tag]
            performSegue(withIdentifier: "toProfileDetail", sender: tagName)
    }
    
    
    // MARK: - Navigation

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seachMemberCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = seachMemberTableView.dequeueReusableCell(withIdentifier: "MCells", for: indexPath)
        let memberNameLabel = cell.viewWithTag(1) as! UILabel
        memberNameLabel.text = seachMemberCells[indexPath.row]

        // オプショナルバインディングを使用してボタンのキャストを安全に行う
        if let button = cell.viewWithTag(999) as? UIButton {
            button.tag = indexPath.row
            button.addTarget(self, action: #selector(self.showProfileButtonTapped(_:)), for: .touchUpInside)
        } else {
            print("Error: Button with tag 999 not found in cell.")
        }

        return cell
    }

    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 15
    }
}
