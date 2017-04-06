//
//  LoginOrRegisterViewController.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

/// 输入用户名页面
class InputUserNameController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Response Event
    
    /// 添加下一步按钮
    ///
    /// - Parameter sender:
    @IBAction func tapNextStepButton(_ sender: UIButton) {
        if userNameTextField.text! == "" {
            Tools.showTap(message: "请输入用户名", superVC: self)
            return
        }
        self.request()
    }
    
    @IBAction func tapGestureRecongnizer(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: - Prevate Method
    
    /// 通过用户名请求信息
    private func request() {
        let userInfoReq = UserInfoRequest(start: {
            
        }, success: { (userModel) in
            dump(userModel)
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

    
    /// 跳转到密码输入页面
    ///
    /// - Parameter userModel: 
    private func goLoginOrRegister(userModel: Any) {
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
}
