//
//  MakeTeamViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import Firebase
import FirebaseDatabase

class MakeTeamViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var teamShowTableView: UITableView!
    var profileDateDic: [String: String] = [:]
    var teamMemberCells: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamShowTableView.delegate = self
        teamShowTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        //中に何かあれば辞書に
        if userDefaults.object(forKey: "add") != nil {
            profileDateDic = userDefaults.object(forKey: "add") as! [String: String]
            print(profileDateDic["team"])
        }
        fetchTeamMembers()
    }
    
    func fetchTeamMembers() {
        guard let teamName = profileDateDic["team"] else { return }

        let ref = Database.database().reference()
        ref.child("teamDate").child(teamName).observe(.value) { (snapshot) in
            var members: [String] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot, let dict = snap.value as? [String: String], let tagName = dict["tagName"] {
                    members.append(tagName)
                }
            }
            self.teamMemberCells = members
            self.teamShowTableView.reloadData()
        }
    }



// MARK: - Navigation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMemberCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamShowTableView.dequeueReusableCell(withIdentifier: "TCells", for: indexPath)
        let memberNameLabel = cell.viewWithTag(1) as! UILabel
        memberNameLabel.text = teamMemberCells[indexPath.row]
        return cell
    }

    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 15
    }

}
