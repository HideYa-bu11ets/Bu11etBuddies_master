//
//  EditAndPostViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/12.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class EditAndPostViewController: UIViewController {
    var passedImage = UIImage()
    
    var userName = String()
    var userImageString = String()
    var userImageData = Data()
    var userImage = UIImage()
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        アプリ内に保存されているデータを呼び出し
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            userImage = UIImage(data: userImageData)!
            
        }
        
        
        //        パーツに反映
        userProfileImageView.image = userImage
        userNameLabel.text = userName
        contentImageView.image = passedImage
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentTextField.resignFirstResponder()
    }
    
    @IBAction func postAction(_ sender: Any) {
        //        データベースの行き先（子）を決める
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
        
        //                ストレージサーバーのURLを取得
        let storage = Storage.storage().reference(forURL: "gs://bu11etbuddies.appspot.com")
        
        /*** アイコンの一連 ***/
        //        ユーザーアイコン用フォルダの作成
        let userKey = timeLineDB.child("Users").childByAutoId().key
        let userImageRef = storage.child("Users").child("\(String(describing: userKey!)).jpg")
        //        データ型の変数を用意しておく
        var userProfileImageData:Data = Data()
        
        //        画像があったら用意した変数（データ型）にサイズ1/100でいれる
        if userProfileImageView.image != nil{
            userProfileImageData = (userProfileImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        /*** 投稿コンテンツ一連 ***/
        //        投稿コンテンツ用のフォルダを作成
        let contentsKey = timeLineDB.child("Contents").childByAutoId().key
        let contentsImageRef = storage.child("Contents").child("\(String(describing: contentsKey!)).jpg")
        
        //        データ型の変数を用意しておく
        var contentImageData:Data = Data()
        
        //        画像があったら用意した変数（データ型）にサイズ1/100でいれる
        if contentImageView.image != nil{
            contentImageData = (contentImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        let uploadTask = userImageRef.putData(userProfileImageData, metadata: nil){
            (metaData,error) in
            
            if error != nil{
                print(error)
                return
            }
            
            let uploadTask2 = contentsImageRef.putData(contentImageData, metadata: nil){
                (metaData,error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                userImageRef.downloadURL { (url, error) in
                    
                    if url != nil{
                        contentsImageRef.downloadURL { (url2, error) in
                            if url2 != nil{
                                
                                //キーバリュー型で送信するものを準備する
                                let timeLineInfo = ["userName":self.userName as Any,"userProfileImage":url?.absoluteString as Any,"contents":url2?.absoluteString as Any, "comment":self.commentTextField.text as Any, "postDate":ServerValue.timestamp()] as [String:Any]
                                timeLineDB.updateChildValues(timeLineInfo)
                                
                                //一つ画面を戻す
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                    }
                }
            }
        }
        
        uploadTask.resume()
        
        
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
