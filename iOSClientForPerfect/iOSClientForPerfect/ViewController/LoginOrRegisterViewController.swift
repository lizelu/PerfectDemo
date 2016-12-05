//
//  LoginOrRegisterViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/5.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

enum VCType {
    case Login, Register
    public func description() -> String {
        switch self {
        case .Login:
            return "登录"
        case .Register:
            return "注册"
        }
    }
    
    public func textPlaceHolder() -> String {
        switch self {
        case .Login:
            return "请输入密码进行登录"
        case .Register:
            return "你尚未注册，请输入密码进行注册"
        }
    }
}

class LoginOrRegisterViewController: UIViewController {

    var userInfo: UserModel!
    var vcType: VCType!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var loginOrRegisterButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
    }
    
    func configVC() {
        if userInfo != nil {
            if userInfo.userId == "" {
                self.vcType = VCType.Register
            } else {
                self.vcType = VCType.Login
            }
            
            self.userNameLabel.text = userInfo.userName
            
            self.title = self.vcType.description()
            self.passwordTextField.placeholder = self.vcType.textPlaceHolder()
           // self.loginOrRegisterButton.setTitle(self.vcType.description(), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapLoginOrRegisterButton(_ sender: UIButton) {
        
    }

}
