//
//  ManagerLoginViewController.swift
//  Grocery
//
//  Created by nikita on 5/4/20.
//  Copyright © 2020 nikita. All rights reserved.
//

import UIKit

class ManagerLoginViewController: UIViewController {
    

    @IBOutlet var loginText: [UITextField]!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.isSecureTextEntry = true

        // Do any additional setup after loading the view.
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
