//
//  LoginOrRegisterViewController.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class InputUserNameController: UIViewController {

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
        
        let userInfoReq = UserInfoRequest(start: { 
            
        }, success: { (userModel) in
            guard let model = userModel as? UserModel else {
                return
            }
            print(model.userId)
            
        }) { (errorMessage) in
            Tools.showTap(message: errorMessage, superVC: self)
        }
        
        userInfoReq.queryUserInfo(userName: userNameTextField.text!)
    }

    @IBAction func tapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
