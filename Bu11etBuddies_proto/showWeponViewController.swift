//
//  showWeponViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 沼田英也 on 2023/09/16.
//

import UIKit
import Kingfisher

class ShowWeponViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemCollection: [String] = []
    @IBOutlet weak var showWeponTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        showWeponTableView.delegate = self
        showWeponTableView.dataSource = self
        
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
