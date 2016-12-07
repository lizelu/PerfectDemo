//
//  LoginOrRegisterViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/5.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit


/// 当前页面类型
///
/// - Login: 登录
/// - Register: 注册
enum VCType {
    case Login
    case Register
    
    /// 页面Title
    ///
    /// - Returns: 页面title
    public func description() -> String {
        switch self {
        case .Login:
            return "登录"
        case .Register:
            return "注册"
        }
    }
    
    /// 返回输入框的PlaceHolder
    ///
    /// - Returns: 返回PlaceHolder信息
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
    var vcType: VCType = .Login
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var loginOrRegisterButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.passwordTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Event Response
    
    /// 点击登录或者注册按钮
    ///
    /// - Parameter sender:
    @IBAction func tapLoginOrRegisterButton(_ sender: UIButton) {
        if passwordTextField.text! == "" {
            Tools.showTap(message: "请输入密码", superVC: self)
            return
        }
        
        switch vcType {
        case .Login:
            self.login()
            
        case .Register:
            self.register()
        }
    }
    
    
    /// 回收键盘
    ///
    /// - Parameter sender:
    @IBAction func tapGestrueRecognizer(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //MARK: - Private Method
    
    /// 配置当前VC
    private func configVC() {
        if userInfo != nil {
            if userInfo.userId == "" {
                self.vcType = VCType.Register
            } else {
                self.vcType = VCType.Login
            }
            
            self.userNameLabel.text = userInfo.userName
            self.title = self.vcType.description()
            self.passwordTextField.placeholder = self.vcType.textPlaceHolder()
        }
    }
    
    
    /// 注册
    private func register() {
        requestObj().register(userName: userInfo.userName, password: passwordTextField.text!)
    }
    
    
    /// 登录
    func login() {
        requestObj().login(userName: userInfo.userName, password: passwordTextField.text!)
    }
    
    
    /// 创建UserInfoRequest对象
    ///
    /// - Returns:
    func requestObj() -> UserInfoRequest {
        return UserInfoRequest(start: {
        }, success: { (userModel) in
            DispatchQueue.main.async {
                self.goMainPage()
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
                Tools.showTap(message: errorMessage, superVC: self)
            }
        }
    }
    
    
    /// 进入首页
    func goMainPage() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainTableViewControllerNav")
        self.present(vc, animated: true) {
             UIApplication.shared.delegate?.window??.rootViewController = vc
        }
    }

}
