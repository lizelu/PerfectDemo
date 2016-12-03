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
            guard let userInfos = json as? [[String: String]] else {
                return
            }
            
            let userModel: UserModel = UserModel()
            
            if !userInfos.isEmpty {
                guard let userInfo = userInfos.first else {
                    return
                }
                
                userModel.userId = userInfo["userId"] ?? ""
            }
            
            self.success(userModel)

        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["userName": userName]
        request.getRequest(path: "\(requestPath)", parameters: params)
        
    }
}
