//
//  SeachAreaViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

class SeachAreaViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
    }
    
    // MARK: - Cell
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchAreaCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = areaTableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath)
        
        //        店舗名
        let storeNameLabel = cell.viewWithTag(1) as! UILabel
        storeNameLabel.text = searchAreaCells[indexPath.row]["エリア"]
        
        //        店舗画像
        let storeImageView = cell.viewWithTag(4) as! UIImageView
        if let imageUrlString = searchAreaCells[indexPath.row]["img_list"],
           let imageUrl = URL(string: imageUrlString),
           !imageUrlString.contains("amazon") {
            storeImageView.kf.setImage(with: imageUrl)
        } else {
            storeImageView.image = UIImage(named: "noimage")
        }
        
        
        //        住所
        let addressLabel = cell.viewWithTag(3) as! UILabel
        addressLabel.text = searchAreaCells[indexPath.row]["住所"]
        
        
        //        料金
        let feeLabel = cell.viewWithTag(3) as! UILabel
        feeLabel.text = searchAreaCells[indexPath.row]["定例会料金・利用料金"]
        
        return cell
    }
    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 3
    }
    
    
}

