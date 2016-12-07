//
//  AccountManager.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class AccountManager: NSObject, NSCoding {
    public var userId: String = ""
    public var userName: String = ""
    public var password: String = ""        //先当Token,正常是不能存储密码的
    public var regestTime: String = ""

    private static var instance: AccountManager! = nil
    static func share() -> AccountManager {
        if instance == nil {
            let obj = getInstanceFromLocation()
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
        self.password = aDecoder.decodeObject(forKey: "password") as! String
        self.regestTime = aDecoder.decodeObject(forKey: "regestTime") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.regestTime, forKey: "regestTime")
    }
    
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
