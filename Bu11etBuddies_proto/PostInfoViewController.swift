//
//  PostInfoViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

class InputViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButton(_ sender: Any) {
        //ユーザー名を一時的に保存
        UserDefaults.standard.set(userNameTextField.text, forKey: "userName")
        //プロフィール画像を10分の1に圧縮して保存
        let data = logoImageView.image?.jpegData(compressionQuality: 0.1)
        UserDefaults.standard.set(data, forKey: "userImage")
        //画面遷移
        let nextVC = self.storyboard?.instantiateViewController(identifier: "nextViewController")as! NextViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        showAlert()
        
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
    
    func checkAlbam(){
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
    
    //画像を受け取るメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage]! as? UIImage {
            UserDefaults.standard.set(editedImage.jpegData(compressionQuality: 0.1), forKey: "userImage")
            logoImageView.image = editedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
