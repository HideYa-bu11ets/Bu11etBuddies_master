//
//  OpeningViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var logInIdTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //どこかタップするとキーボードが降りる関数
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        logInIdTextField.resignFirstResponder()
        passWordTextField.resignFirstResponder()
    }
    
    @IBAction func logInButton(_ sender: Any) {
    }
    @IBAction func addNewMenberButton(_ sender: Any) {
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