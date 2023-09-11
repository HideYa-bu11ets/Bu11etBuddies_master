//
//  RegisterViewController.swift
//  Bu11etBuddies_proto
//
//  Created by 櫻木颯大 on 2023/09/11.
//

import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var tagNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var periodField: UITextField!
    @IBOutlet weak var killField: UITextField!
    @IBOutlet weak var deathField: UITextField!
    @IBOutlet weak var bithDayField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
