//
//  PerfectNoteOperator.swift
//  PerfectTemplate
//
//  Created by Mr.LuDashi on 2016/12/2.
//
//

import Foundation
import MySQL
import PerfectLogger
class PerfectNoteOperator {
    let dataBaseName = "perfect_note"
    let userTableName = "user"
    
    var mysql: MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    
    //MARK: - Operator User Table
    func insertUserInfo(userName: String, password: String) {
        let values = "('\(userName)', '\(password)')"
        let statement = "insert into \(userTableName) (username, password) values \(values)"
        LogFile.info("执行SQL:\(statement)")
        
        guard mysql.query(statement: statement) else {
            LogFile.error("\(statement)插入失败")
            return
        }
        
        LogFile.info("插入成功")
    }
    
    
    
}
