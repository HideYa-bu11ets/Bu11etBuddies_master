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
    @IBOutlet weak var bithDayTextField: UITextField!
    
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
        bithDayTextField.resignFirstResponder()
    }

    @IBAction func sexSegment(_ sender: Any) {
        
    }
    
    @IBAction func commitButton(_ sender: Any) {
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
