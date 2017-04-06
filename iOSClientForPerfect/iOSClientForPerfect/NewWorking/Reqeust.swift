//
//  Reqeust.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation

//返回数据解析中使用的字符串常量
let RequestResultSuccess: String = "SUCCESS"
let RequestResultFaile: String = "FAILE"
let ResultListKey = "list"
let ResultKey = "result"
let ErrorMessageKey = "errorMessage"

//网络请求中的闭包回调
typealias RequestStart = () -> Void         //开始请求
typealias RequestSuccess = (Any) -> Void    //请求成功
typealias RequestFailed = (String) -> Void  //请求失败

//请求方式枚举
enum RequestMethodTypes {
    case GET, POST, PUT, DELETE, CUSTOM(String)
    
    /// Convert to String
    public var description: String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        case .PUT: return "PUT"
        case .DELETE: return "DELETE"
        case .CUSTOM(let s): return s
        }
    }
}

//网络请求基类
class BaseRequest {
    var start: RequestStart
    var success: RequestSuccess
    var faile: RequestFailed
    
    init(start: @escaping RequestStart,
         success: @escaping RequestSuccess,
         faile: @escaping RequestFailed) {
        self.start = start
        self.success = success
        self.faile = faile
    }
}

//网络请求类--URLSession
class Request: BaseRequest {
    /// GET请求
    ///
    /// - Parameters:
    ///   - path: 请求路径
    ///   - parameters: 请求参数
    func getRequest(path:String,
                    parameters:[String:String]) {
        self.sessionDataTaskRequest(method: .GET, path: path, parameters: parameters)
    }
    /// POST请求
    ///
    /// - Parameters:
    ///   - path: 请求路径
    ///   - parameters: 请求参数
    func postRequest(path:String,
                     parameters:[String:String]) {
        self.sessionDataTaskRequest(method: .POST, path: path, parameters: parameters)
    }
    /// PUT请求
    ///
    /// - Parameters:
    ///   - path: 请求路径
    ///   - parameters: 请求参数
    func putRequest(path:String,
                    parameters:[String:String]) {
        self.sessionDataTaskRequest(method: .PUT, path: path, parameters: parameters)
    }
    /// DELETE请求
    ///
    /// - Parameters:
    ///   - path: 请求路径
    ///   - parameters: 请求参数
    func deleteRequest(path:String,
                    parameters:[String:String]) {
        self.sessionDataTaskRequest(method: .DELETE, path: path, parameters: parameters)
    }
    
    /**
     NSURLSessionDataTask
     - parameter method:     请求方式：POST或者GET
     - parameter parameters: 字典形式的参数
     */
    
    func sessionDataTaskRequest(method: RequestMethodTypes,
                                path: String,
                                parameters:[String:String]){
        //1.创建会话用的URL
        var hostString = path//"http://127.0.0.1:8181/params"
        let escapeQueryString = query(parameters)   //对参数进行URL编码
        if method.description == "GET" {
            hostString += "?" + escapeQueryString
        }
       
        //2.创建Request
        let url: URL = URL(string: hostString)!
        let request: NSMutableURLRequest = NSMutableURLRequest.init(url: url)
        request.httpMethod = method.description //指定请求方式
        if method.description != "GET" {
            request.httpBody = escapeQueryString.data(using: String.Encoding.utf8)
        }
        
        print(parameters)
        //3.获取Session单例，创建SessionDataTask
        let session: URLSession = URLSession.shared
        let sessionTask: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            if data != nil {    //对Data进行Json解析
                guard let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) else {
                    return
                }
            
                guard let jsonDic = json as? [String: Any] else {
                    return
                }
                
                guard let result = jsonDic[ResultKey] as? String else {
                    return
                }
                //响应成功
                if result == RequestResultSuccess {
                    print(jsonDic)
                    self.success(jsonDic)
                    return
                }
                //响应失败
                if result == RequestResultFaile {
                    guard let errorMessage = jsonDic[ErrorMessageKey] as? String else {
                        return
                    }
                    self.faile(errorMessage)
                    return
                }
            }
        });
        sessionTask.resume()
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            components.append((escape(key), escape("\(value)")))
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    /**
     
     - parameter string: 要转义的字符串
     
     - returns: 转义后的字符串
     */
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }

}
