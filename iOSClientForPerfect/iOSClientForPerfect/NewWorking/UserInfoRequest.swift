//
//  UserInfoRequest.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class UserInfoRequest: BaseRequest {
    
    func queryUserInfo(userName: String){
        let requestPath = "\(RequestHome)\(RequestUserInfoPath)"
        let request = Request(start: { 
            self.start()
        }, success: { (json) in
            guard let userInfos = json as? [String: Any] else {
                return
            }
            
            let userModel: UserModel = UserModel()
            
            if userInfos["list"] != nil {
                guard let userInfo = userInfos["list"]! as? [String:String] else {
                    return
                }
                
                userModel.userId = userInfo["userId"] ?? ""
                userModel.userName = userInfo["userName"] ?? ""
            }
            
            self.success(userModel)

        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["userName": userName]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    func login(userName: String, password: String){
        loginOrRegister(requestPath: "\(RequestHome)\(RequestUserLogin)", userName: userName, password: password)
    }
    
    func register(userName: String, password: String){
        loginOrRegister(requestPath: "\(RequestHome)\(RequestUserRegister)", userName: userName, password: password)
    }
    
    func loginOrRegister(requestPath: String, userName: String, password: String) {
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            guard let userInfos = json as? [String: Any] else {
                return
            }
            
            let userModel: UserModel = UserModel()
            
            if userInfos["list"] != nil {
                guard let userInfo = userInfos["list"]! as? [String:String] else {
                    return
                }
                
                userModel.userId = userInfo["userId"] ?? ""
                userModel.userName = userInfo["userName"] ?? ""
                userModel.password = userInfo["password"] ?? ""
                userModel.regestTime = userInfo["registerTime"] ?? ""
            }
            AccountManager.share().userId = userModel.userId
            AccountManager.share().userName = userModel.userName
            AccountManager.share().password = userModel.password
            AccountManager.share().regestTime = userModel.regestTime
            self.recoderUserInfo()
            self.success(userModel)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["userName": userName, "password": password]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    func recoderUserInfo() {
        let data = NSKeyedArchiver.archivedData(withRootObject: AccountManager.share())
        UserDefaults.standard.setValue(data, forKey: LoginUserInfoKey)
    }
    
    static func loginOut() {
        UserDefaults.standard.removeObject(forKey: LoginUserInfoKey)
    }
}
