//
//  NextViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/12.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import Photos


class NextViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var timeLineTableView: UITableView!
    
    var userName = String()
    var userImageData = Data()
    var userImage = UIImage()
    var commentString = String()
    var createDate = String()
    var contentImageString = String()
    var userProfileImageString = String()
    var selectedImage = UIImage()
    var contentsArray = [Contents]()

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        if UserDefaults.standard.object(forKey: "userName") != nil{
            
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            userImage = UIImage(data: userImageData)!
            
        }
        fetchContentsData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //        コンテンツ
        //        タグで管理
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        profileImageView.kf.setImage(with: URL(string: contentsArray[indexPath.row].profileImageString))
        
        profileImageView.layer.cornerRadius = 30.0
        
        //        ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = contentsArray[indexPath.row].userNameString
        
        //        投稿日時
        let dateLabel = cell.viewWithTag(3) as! UILabel
        dateLabel.text = contentsArray[indexPath.row].postDateString
        
        //        投稿画像
        let contentImageView = cell.viewWithTag(4) as! UIImageView
        contentImageView.kf.setImage(with: URL(string: contentsArray[indexPath.row].contentImageString))
        
        //        コメント
        let commentLabel = cell.viewWithTag(5) as! UILabel
        commentLabel.text = contentsArray[indexPath.row].commentString
        
        return cell
    }
    
    //    セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 2 / 3
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        showAlert()
    }
    
    func convertTimeStamp(serverTimeStamp:CLong) -> String{
        let x = serverTimeStamp / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(x))
        let formatter  = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date)
        
    }
    
    /* データの受信 */
    func fetchContentsData(){
        
        let ref = Database.database().reference().child("timeLine").queryLimited(toLast: 100).queryOrdered(byChild: "postDate").observe(.value) { (snapShot) in
            
            self.contentsArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let postData = snap.value as? [String:Any]{
                        
                        let userName = postData["userName"] as? String
                        let userProfileImage = postData["userProfileImage"] as? String
                        let contents = postData["contents"] as? String
                        let comment = postData["comment"] as? String
                        var postDate:CLong?
                        if let postedDate = postData["postDate"] as? CLong{
                            
                            postDate = postedDate
                            
                            //postDateを時間に変換していきます。
                            let timeString = self.convertTimeStamp(serverTimeStamp: postDate!)
                            self.contentsArray.append(Contents(userNameString: userName!, profileImageString: userProfileImage!, contentImageString: contents!, commentString:comment!, postDateString: timeString))
                            
                            
                        }
                        
                        
                    }
                }
                self.timeLineTableView.reloadData()
                let indexPath = IndexPath(row: self.contentsArray.count - 1, section: 0)
                if self.contentsArray.count >= 5{
                    
                    self.timeLineTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                }
            }
        }
    }
    
    //    カメラ立ち上げメソッド
    func checkCamera(){
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //        カメラ利用可能かチェック
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            present(cameraPicker, animated: true,completion: nil)
            
        }
    }
    
    //    フォトライブラリの使用
    func checkAlbam() {
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //        フォトライブラリのチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            present(cameraPicker, animated: true,completion: nil)
        }
    }
    
    //    アラートでカメラorアルバムの選択をさせる
    func showAlert(){
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.checkCamera()
        }
        
        let albamAction = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.checkAlbam()
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        alertController.addAction(cameraAction)
        alertController.addAction(albamAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
    }
    
    //    キャンセル時の処理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    画像が選択 or カメラ撮影 の後に呼び出されるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[.editedImage] as! UIImage
        
        //        ナビゲーションを用いて画面遷移
        let editPostVC = self.storyboard?.instantiateViewController(identifier: "EditAndPost") as! EditAndPostViewController
        
        editPostVC.passedImage = selectedImage
        
        self.navigationController?.pushViewController(editPostVC, animated: true)
        
        //        ピッカーを閉じる
        picker.dismiss(animated: true, completion: nil)
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
