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
        if userNameTextField.text! == "" {
            Tools.showTap(message: "请输入用户名", superVC: self)
            return
        }
        
        let userInfoReq = UserInfoRequest(start: {

        }, success: { (userModel) in
            DispatchQueue.main.async {
                self.goLoginOrRegister(userModel: userModel)
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
               Tools.showTap(message: errorMessage, superVC: self)
            }
        }
        
        userInfoReq.queryUserInfo(userName: userNameTextField.text!)
    }

    func goLoginOrRegister(userModel: Any) {
        guard let model = userModel as? UserModel else {
            return
        }
        
        if model.userName == "" {
            model.userName = self.userNameTextField.text!
        }

        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginOrRegisterViewController") as? LoginOrRegisterViewController else {
            return
        }
        vc.userInfo = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
