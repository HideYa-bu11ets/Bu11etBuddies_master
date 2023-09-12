//
//  RegisterViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var periodTextField: UITextField!
    @IBOutlet weak var killTextField: UITextField!
    @IBOutlet weak var deathTextField: UITextField!
    @IBOutlet weak var birthDayTextField: UITextField!
    
    //空の辞書
    var profileDateDic: [String: String?] = [:]
    var sex = "Men"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        profileDateDic["tagName"] = tagNameTextField.text
        profileDateDic["age"] = ageTextField.text
        profileDateDic["period"] = periodTextField.text
        profileDateDic["kill"] = killTextField.text
        profileDateDic["death"] = deathTextField.text
        profileDateDic["birthDay"] = birthDayTextField.text
        profileDateDic["sex"] = sex

        
        print(profileDateDic)
        self.dismiss(animated: true, completion: nil)
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
