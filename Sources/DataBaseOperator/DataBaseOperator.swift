//
//  DataBaseOperator.swift
//  PerfectTemplate
//
//  Created by Mr.LuDashi on 2016/12/2.
//
//

import Foundation
import MySQL
import PerfectLogger


/// 连接MySql数据库的类
class MySQLConnect {
    var host: String {
        get {
            return "127.0.0.1"
        }
    }
    
    var port: String {
        get {
            return "3306"
        }
    }
    
    var user: String {
        get {
            return "root"
        }
    }
    
    var password: String {
        get {
            return "admin!@#"
        }
    }
    
    private var connect: MySQL!
    private static var instance: MySQL!
    public static func shareInstance(dataBaseName: String) -> MySQL{
        if instance == nil {
            instance = MySQLConnect(dataBaseName: dataBaseName).connect
        }
        
        return instance
    }
    
    private init(dataBaseName: String) {
        self.connectDataBase()
        self.selectDataBase(name: dataBaseName)
    }
    
    private func connectDataBase() {
        if connect == nil {
            connect = MySQL()
        }
        
        let connected = connect.connect(host: "\(host)", user: user, password: password)
        guard connected else {// 验证一下连接是否成功
            LogFile.error(connect.errorMessage())
            return
        }
        
        LogFile.info("数据库连接成功")
    }
    
    func selectDataBase(name: String){
        // 选择具体的数据Schema
        guard connect.selectDatabase(named: name) else {
            LogFile.error("数据库选择失败。错误代码：\(connect.errorCode()) 错误解释：\(connect.errorMessage())")
            return
        }
        
        LogFile.info("连接Schema：\(name)成功")
    }
    
    deinit {
    }
}
