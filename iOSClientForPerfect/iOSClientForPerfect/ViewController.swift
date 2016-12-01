//
//  ViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/11/30.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit
enum RequestMethodType: Int {
    case GET = 0
    case POST
    case PUT
    case DELETE
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Event Response
    
    @IBAction func tapRequestButton(_ sender: UIButton) {
        
        let method = requsetMethod(tag: sender.tag)
        let parameters = ["userName":"ZeluLi", "password":"qwert","Tel":"1234"]
        sessionDataTaskRequest(method: method, parameters: parameters as [String:AnyObject])
    }
    
    func requsetMethod(tag: Int) -> String {
        guard let methodType: RequestMethodType = RequestMethodType(rawValue:tag) else {
            return "GET"
        }
        switch methodType {
        case .GET:
            return "GET"
        
        case .POST:
            return "POST"
            
        case .PUT:
            return "PUT"
            
        case .DELETE:
            return "DELETE"
        }
    }
    
    /**
     NSURLSessionDataTask
     - parameter method:     请求方式：POST或者GET
     - parameter parameters: 字典形式的参数
     */
    
    func sessionDataTaskRequest(method: String, parameters:[String:AnyObject]){
        //1.创建会话用的URL
        var hostString = "http://127.0.0.1:8181/params"
        let escapeQueryString = query(parameters)   //对参数进行URL编码
        if method == "GET" {
            hostString += "?" + escapeQueryString
        }
        let url: URL = URL(string: hostString)!
        
        //2.创建Request
        let request: NSMutableURLRequest = NSMutableURLRequest.init(url: url)
        request.httpMethod = method //指定请求方式
        if method != "GET" {
            request.httpBody = escapeQueryString.data(using: String.Encoding.utf8)
        }
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
                print(json)
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

