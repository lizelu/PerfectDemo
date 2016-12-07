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
    
    //单例
    private static var mysql: MySQL!
    public static func shareInstance(dataBaseName: String) -> MySQL{
        if mysql == nil {
            mysql = MySQLConnect(dataBaseName: dataBaseName).connect
        }
        return mysql
    }
    
    private init(dataBaseName: String) {
        self.connectDataBase()
        self.selectDataBase(name: dataBaseName)
    }
    
    
    /// 连接数据库
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
    
    
    /// 选择Scheme
    ///
    /// - Parameter name: <#name description#>
    func selectDataBase(name: String){
        // 选择具体的数据Schema
        guard connect.selectDatabase(named: name) else {
            LogFile.error("数据库选择失败。错误代码：\(connect.errorCode()) 错误解释：\(connect.errorMessage())")
            return
        }
        
        LogFile.info("连接Schema：\(name)成功")
    }
    
    deinit {
        //关闭数据库
        connect.close()
    }
}
