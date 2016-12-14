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


/// 操作数据库的基类
class BaseOperator {
    let dataBaseName = "perfect_note"
    var mysql: MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    var responseJson: [String : Any] = BaseResponseJson
}


/// 操作用户相关的数据表
class UserOperator: BaseOperator {
    let userTableName = "user"
    
    /// 由用户名查询用户信息
    ///
    /// - Parameter userName: 用户名
    /// - Returns: 返回JSON数据
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
            let results = mysql.storeResults()!
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
    
    
    /// 由用户名和密码查询用户信息
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 用户密码
    /// - Returns:
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




/// 操作内容相关的数据表
class ContentOperator: BaseOperator {
    let contentTableName = "content"
    
    
    /// 添加比较
    ///
    /// - Parameters:
    ///   - userId: 用户ID
    ///   - title: 标题
    ///   - content: 内容
    /// - Returns: 返回结果JSON
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
    
    
    /// 查询Note列表
    ///
    /// - Parameter userId: 用户ID
    /// - Returns: 返回JSON
    func queryContentList(userId: String) -> String? {
        let statement = "select id, title, content, create_time from \(contentTableName) where userID='\(userId)'"
        LogFile.info("执行SQL:\(statement)")
        print(mysql)
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
            LogFile.error("\(statement)查询失败")
        } else {
            LogFile.info("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
            
            var ary = [[String:String]]() //创建一个字典数组用于存储结果
            if results.numRows() == 0 {
                LogFile.info("\(statement)尚没有录入新的Note, 请添加！")
            } else {
                results.forEachRow { row in
                    var dic = [String:String]() //创建一个字典用于存储结果
                    dic["contentId"] = "\(row[0]!)"
                    dic["title"] = "\(row[1]!)"
                    dic["content"] = "\(row[2]!)"
                    dic["time"] = "\(row[3]!)"
                    ary.append(dic)
                }
                self.responseJson[ResultListKey] = ary
            }
            self.responseJson[ResultKey] = RequestResultSuccess
        }
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 查询Note详情
    ///
    /// - Parameter contentId: 内容ID
    /// - Returns: 返回相关JOSN
    func queryContentDetail(contentId: String) -> String? {
        let statement = "select content from \(contentTableName) where id='\(contentId)'"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "查询失败"
            LogFile.error("\(statement)查询失败")
        } else {
            LogFile.info("SQL:\(statement)查询成功")
            
            // 在当前会话过程中保存查询结果
            let results = mysql.storeResults()!
            
            var dic = [String:String]() //创建一个字典数于存储结果
            if results.numRows() == 0 {
                self.responseJson[ResultKey] = RequestResultFaile
                self.responseJson[ErrorMessageKey] = "获取Note详情失败！"
                LogFile.error("\(statement)获取Note详情失败！")
            } else {
                results.forEachRow { row in
                    guard let content = row.first! else {
                        return
                    }
                    dic["content"] = "\(content)"
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
    
    
    /// 更新内容
    ///
    /// - Parameters:
    ///   - contentId: 更新内容的ID
    ///   - title: 标题
    ///   - content: 内容
    /// - Returns: 返回结果JSON
    func updateContent(contentId: String, title: String, content: String) -> String? {
        let statement = "update \(contentTableName) set title='\(title)', content='\(content)', create_time=now() where id='\(contentId)'"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "更新失败"
            LogFile.error("\(statement)更新失败")
        } else {
            LogFile.info("SQL:\(statement) 更新成功")
            self.responseJson[ResultKey] = RequestResultSuccess
        }
        
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }
    
    
    /// 删除内容
    ///
    /// - Parameter contentId: 删除内容的ID
    /// - Returns: 返回删除结果
    func deleteContent(contentId: String) -> String? {
        let statement = "delete from \(contentTableName) where id='\(contentId)'"
        LogFile.info("执行SQL:\(statement)")
        
        if !mysql.query(statement: statement) {
            self.responseJson[ResultKey] = RequestResultFaile
            self.responseJson[ErrorMessageKey] = "删除失败"
            LogFile.error("\(statement)删除失败")
        } else {
            LogFile.info("SQL:\(statement) 删除成功")
            self.responseJson[ResultKey] = RequestResultSuccess
        }
        
        guard let josn = try? responseJson.jsonEncodedString() else {
            return nil
        }
        return josn
    }


}
