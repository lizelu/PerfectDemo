//
//  AccountManager.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation

/// 用户信息单例
class AccountManager: NSObject, NSCoding {
    public var userId: String = ""
    public var userName: String = ""
    public var regestTime: String = ""

    //获取单例的方法
    private static var instance: AccountManager! = nil
    static func share() -> AccountManager {
        if instance == nil {
            let obj = getInstanceFromLocation()     //解归档
            if obj != nil {
                instance = obj!
            } else {
                instance = AccountManager()
            }
        }
        return instance
    }
    
    private override init() {}
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.userId = aDecoder.decodeObject(forKey: "userId") as! String
        self.userName = aDecoder.decodeObject(forKey: "userName") as! String
        self.regestTime = aDecoder.decodeObject(forKey: "regestTime") as! String
    }
    
    /// 归档
    ///
    /// - Parameter aCoder: <#aCoder description#>
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.regestTime, forKey: "regestTime")
    }
    
    
    /// 从UserDefault中进行解归档
    ///
    /// - Returns: <#return value description#>
    static func getInstanceFromLocation() -> AccountManager? {
        guard let data = UserDefaults.standard.value(forKey: LoginUserInfoKey) as? Data else {
            return nil
        }
        
        guard let instance = NSKeyedUnarchiver.unarchiveObject(with: data) as? AccountManager else {
            return nil
        }
        
        return instance
    }

}
