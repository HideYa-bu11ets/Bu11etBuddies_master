//
//  RegisterViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

    let ref = Database.database().reference()
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var killTextField: UITextField!
    @IBOutlet weak var deathTextField: UITextField!
    @IBOutlet weak var birthDayTextField: UITextField!
    
    //空の辞書
    var profileDateDic: [String: String] = [:]
    var sex = "Men"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        //中に何かあれば辞書に
        if userDefaults.object(forKey: "add") != nil {
            profileDateDic = userDefaults.object(forKey: "add") as! [String: String]
            print(profileDateDic)
            //これで前入力したものがテキストフィールドに表示される(セグメント以外)
            tagNameTextField.text = profileDateDic["tagName"]
            ageTextField.text = profileDateDic["age"]
            periodTextField.text = profileDateDic["period"]
            killTextField.text = profileDateDic["kill"]
            deathTextField.text = profileDateDic["death"]
            birthDayTextField.text = profileDateDic["birthDay"]
            //これで前入力したものがテキストフィールドに表示される(セグメント以外)
        }
        
    }
    
    //どこかタップするとキーボードが降りる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tagNameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        periodTextField.resignFirstResponder()
        killTextField.resignFirstResponder()
        deathTextField.resignFirstResponder()
        birthDayTextField.resignFirstResponder()
    }

    @IBAction func sexSegment(_ sender: UISegmentedControl) {
        //セグメントの条件: 0なら辞書にmenを,1ならwomen,何も押さなくてもmen
        switch sender.selectedSegmentIndex {
        case 0:
                sex = "Men"
                profileDateDic["sex"] = sex
            case 1:
                sex = "Women"
                profileDateDic["sex"] = sex
            default:
                break
            }
        }
    
    @IBAction func commitButton(_ sender: Any) {
        //テキストフィールドの文字を辞書に格納（オプショナルバインディングを使用）
        if let tagName = tagNameTextField.text {
            profileDateDic["tagName"] = tagName
        }
        
        if let age = ageTextField.text {
            profileDateDic["age"] = age
        }
        
        if let period = periodTextField.text {
            profileDateDic["period"] = period
        }
        
        if let kill = killTextField.text {
            profileDateDic["kill"] = kill
        }
        
        if let death = deathTextField.text {
            profileDateDic["death"] = death
        }
        
        if let birthDay = birthDayTextField.text {
            profileDateDic["birthDay"] = birthDay
        }
        
        profileDateDic["sex"] = sex
        
        //キーaddで保存
        UserDefaults.standard.set(profileDateDic, forKey: "add")
        
        ref.child("profiles").childByAutoId().setValue(profileDateDic)
        //前画面に遷移
        self.navigationController?.popViewController(animated: true)
        print(profileDateDic)
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
