//
//  UserInfoRequest.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class UserInfoRequest: BaseRequest {
    let requestPath = "\(RequestHome)\(RequestUserInfoPath)"
    
    func queryUserInfo(userName: String){
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
            
            self.success(userModel)

        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["userName": userName]
        request.getRequest(path: "\(requestPath)", parameters: params)
        
    }
}
