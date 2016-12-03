//
//  LoginOrRegisterViewController.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class LoginOrRegisterViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapNextStepButton(_ sender: UIButton) {
        if userNameTextField.text == "" {
            Tools.showTap(message: "请输入用户名", superVC: self)
            return
        }
    }

    @IBAction func tapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
