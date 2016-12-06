//
//  UserModel.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class UserModel {
    public var userId: String = ""
    public var userName: String = ""
    public var password: String = ""        //先当Token,正常是不能存储密码的
    public var regestTime: String = ""
}
