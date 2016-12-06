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
let RequestResultSuccess: String = "SUCCESS"
let RequestResultFaile: String = "FAILE"
let ResultListKey = "list"
let ResultKey = "result"
let ErrorMessageKey = "errorMessage"
var BaseResponseJson: [String : Any] = [ResultListKey:[], ResultKey:RequestResultSuccess, ErrorMessageKey:""]


class BaseOperator {
     let dataBaseName = "perfect_note"
    var mysql: MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    
    var responseJson: [String : Any] = BaseResponseJson    
    
}

class UserOperator: BaseOperator {
   
    let userTableName = "user"
    
    //MARK: - Insert User Info,返回用户信息
    func queryUserInfo(userName: String) -> String? {
        let statement = "select id, username from user where username = '\(userName)'"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
            LogFile.error("\(statement)查询失败")
        } else {
            LogFile.info("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
            
            var dic = [String:String]() //创建一个字典数组用于存储结果
            
            results.forEachRow { row in
                guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                    return
                }
                dic["userId"] = "\(userId)"
                dic["userName"] = "\(row[1]!)"
            }
            
            self.responseJson[ResultKey] = RequestResultSuccess
            self.responseJson[ResultListKey] = dic
        }
        
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    //MARK: - Insert User Info,返回用户信息
    func queryUserInfo(userName: String, password: String) -> String? {
        let statement = "select * from user where username='\(userName)' and password='\(password)'"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
            LogFile.error("\(statement)查询失败")
        } else {
            LogFile.info("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
            
            var dic = [String:String]() //创建一个字典数组用于存储结果
            if results.numRows() == 0 {
                self.responseJson[ResultKey] = RequestResultFaile
                self.responseJson[ErrorMessageKey] = "用户名或密码错误，请重新输入！"
                LogFile.error("\(statement)用户名或密码错误，请重新输入")
            } else {
                results.forEachRow { row in
                    guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                        return
                    }
                    dic["userId"] = "\(userId)"
                    dic["userName"] = "\(row[1]!)"
                    dic["password"] = "\(row[2]!)"
                    dic["registerTime"] = "\(row[3]!)"
                }
                
                self.responseJson[ResultKey] = RequestResultSuccess
                self.responseJson[ResultListKey] = dic

            }
        }
        
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }

    
    
    
    /// insert user info
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 密码
    func insertUserInfo(userName: String, password: String) -> String? {
        let values = "('\(userName)', '\(password)')"
        let statement = "insert into \(userTableName) (username, password) values \(values)"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            LogFile.error("\(statement)插入失败")
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "创建\(userName)失败"
            guard let josn = try? responseJson.jsonEncodedString() else {
                return nil
            }
            return josn
        } else {
            LogFile.info("插入成功")
            return queryUserInfo(userName: userName, password: password)
        }
    }
}

class ContentOperator: BaseOperator {
    let contentTableName = "content"
    
    func addContent(userId: String, title: String, content: String) -> String? {
        
        let values = "('\(userId)', '\(title)', '\(content)')"
        let statement = "insert into \(contentTableName) (userID, title, content) values \(values)"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            LogFile.error("\(statement)插入失败")
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "创建\(title)失败"
        } else {
            LogFile.info("插入成功")
            self.responseJson[ResultKey] = RequestResultSuccess
        }
        
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn

    }
}
