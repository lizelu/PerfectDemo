//
//  AccountManager.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class AccountManager {
    var userInfo: UserModel! = nil
    private static var instance: AccountManager! = nil
    static func share() -> AccountManager {
        if instance == nil {
           instance = AccountManager()
        }
        return instance
    }
    
    private init() {}
    
}
