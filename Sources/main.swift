//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectRequestLogger
import PerfectLogger
import MySQL

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()


//MARK: - Note
//根据用户名查询用户ID
routes.add(method: .post, uri: "/queryUserInfoByUserName") { (request, response) in
    guard let userName: String = request.param(name: "userName") else {
        LogFile.error("userName为nil")
        return
    }
    guard let json = UserOperator().queryUserInfo(userName: userName) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//注册
routes.add(method: .post, uri: "/register") { (request, response) in
    guard let userName: String = request.param(name: "userName") else {
        LogFile.error("userName为nil")
        return
    }
    
    guard let password: String = request.param(name: "password") else {
        LogFile.error("password为nil")
        return
    }
    guard let json = UserOperator().insertUserInfo(userName: userName, password: password) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//登录
routes.add(method: .post, uri: "/login") { (request, response) in
    guard let userName: String = request.param(name: "userName") else {
        LogFile.error("userName为nil")
        return
    }
    guard let password: String = request.param(name: "password") else {
        LogFile.error("password为nil")
        return
    }
    guard let json = UserOperator().queryUserInfo (userName: userName, password: password) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//获取内容列表
routes.add(method: .post, uri: "/contentList") { (request, response) in
    guard let userId: String = request.param(name: "userId") else {
        LogFile.error("userId为nil")
        return
    }
    
    guard let json = ContentOperator().queryContentList(userId: userId) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//获取详情
routes.add(method: .post, uri: "/contentDetail") { (request, response) in
    guard let contentId: String = request.param(name: "contentId") else {
        LogFile.error("contentId为nil")
        return
    }
    guard let json = ContentOperator().queryContentDetail(contentId: contentId) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//添加内容
routes.add(method: .post, uri: "/contentAdd") { (request, response) in
    guard let userId: String = request.param(name: "userId") else {
        LogFile.error("userId为nil")
        return
    }
    
    guard let title: String = request.param(name: "title") else {
        LogFile.error("title为nil")
        return
    }
    
    guard let content: String = request.param(name: "content") else {
        LogFile.error("content为nil")
        return
    }
    
    guard let json = ContentOperator().addContent(userId: userId, title: title, content: content) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//更新内容
routes.add(method: .post, uri: "/contentUpdate") { (request, response) in
    guard let contentId: String = request.param(name: "contentId") else {
        LogFile.error("contentId为nil")
        return
    }
    
    guard let title: String = request.param(name: "title") else {
        LogFile.error("title为nil")
        return
    }
    
    guard let content: String = request.param(name: "content") else {
        LogFile.error("content为nil")
        return
    }
    
    guard let json = ContentOperator().updateContent(contentId: contentId, title: title, content: content) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}

//删除内容
routes.add(method: .post, uri: "/contentDelete") { (request, response) in
    guard let contentId: String = request.param(name: "contentId") else {
        LogFile.error("contentId为nil")
        return
    }
    
    guard let json = ContentOperator().deleteContent(contentId: contentId) else {
        LogFile.error("josn为nil")
        return
    }
    LogFile.info(json)
    response.setBody(string: json)
    response.completed()
}












//MARK: - 路由
//MARK: - 路由变量
let valueKey = "key"
routes.add(method: .get, uri: "/path1/{\(valueKey)}/detail") { (request, response) in
    response.appendBody(string: "该URL中的路由变量为：\(request.urlVariables[valueKey])")
    response.completed()
}

//MARK: - 静态路由
routes.add(method: .get, uri: "/hello", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>你好!</title><body>你好!</body></html>")
		response.completed()
	}
)

//MAKR: - 通配符路径
routes.add(method: .get, uri: "/path2/*/detail") { (request, response) in
    response.appendBody(string: "通配符URL为：\(request.path)")
    response.completed()
}

//MAKR: - 结尾通配符
routes.add(method: .get, uri: "/path3/**") { (request, response) in
    response.appendBody(string: "该URL中的结尾通配符对应的变量：\(request.urlVariables[routeTrailingWildcardKey])")
    response.completed()
}

//优先级：路由变量 > 静态路由 > 通配符路径 > 结尾通配符






//MARK: - 配置路由版本
// 为程序接口API版本v1创建路由表
var api = Routes()
api.add(method: .get, uri: "/call1", handler: { _, response in
    response.setBody(string: "程序接口API版本v1已经调用")
    response.completed()
})
api.add(method: .get, uri: "/call2", handler: { _, response in
    response.setBody(string: "程序接口API版本v2已经调用")
    response.completed()
})

var api1Routes = Routes(baseUri: "/v1") // API版本v1
var api2Routes = Routes(baseUri: "/v2") // API版本v2

api1Routes.add(api) // 为API版本v1增加主调函数
api2Routes.add(api) // 为API版本v2增加主调函数

// 更新API版本v2主调函数
api2Routes.add(method: .get, uri: "/call2", handler: { _, response in
    response.setBody(string: "程序接口API版本v2已经调用第二种方法")
    response.completed()
})

// 将两个版本的内容都注册到服务器主路由表上
routes.add(api1Routes)
routes.add(api2Routes)






//MARK: - 返回图片
routes.add(method: .get, uri: "/cat", handler: {
        request, response in
        let docRoot = request.documentRoot
        do {
            let cat = File("\(docRoot)/img/cat.jpg")
            let imageSize = cat.size
            let imageBytes = try cat.readSomeBytes(count: imageSize)
            response.setHeader(.contentType, value: MimeType.forExtension("jpg"))
            response.setHeader(.contentLength, value: "\(imageBytes.count)")
            response.setBody(bytes: imageBytes)
        } catch {
            response.status = .internalServerError
            response.setBody(string: "请求处理出现错误： \(error)")
        }
        response.completed()
    }
)




//MARK: - 获取请求参数:
func convertJons(params: [(String, String)]) -> String{
    var jsonDic:[String:String] = [:]
    for item in params {
        jsonDic[item.0] = item.1
    }
    
    guard let json = try? jsonDic.jsonEncodedString() else {
        return ""
    }
    LogFile.debug(json)
    return json
}


func requestHandler(request: HTTPRequest, response:HTTPResponse) {
    response.setBody(string: convertJons(params:request.params()))
    response.completed()
}



routes.add(method: .delete, uri: "/user") { (request, response) in
   requestHandler(request: request, response: response)
}

//MARK: - 文件上传
// 创建路径用于存储已上传文件
let fileDir = Dir(Dir.workingDir.path + "files")
do {
    try fileDir.create()
} catch {
    print(error)
}
routes.add(method: .post, uri: "/upload") { (request, response) in
    // 通过操作fileUploads数组来掌握文件上传的情况
    // 如果这个POST请求不是分段multi-part类型，则该数组内容为空
    
    if let uploads = request.postFileUploads, uploads.count > 0 {
        // 创建一个字典数组用于检查已经上载的内容
        var ary = [[String:Any]]()
        
        for upload in uploads {
            ary.append([
                "fieldName": upload.fieldName,  //字段名
                "contentType": upload.contentType, //文件内容类型
                "fileName": upload.fileName,    //文件名
                "fileSize": upload.fileSize,    //文件尺寸
                "tmpFileName": upload.tmpFileName   //上载后的临时文件名
                ])
            
                // 将文件转移走，如果目标位置已经有同名文件则进行覆盖操作。
                let thisFile = File(upload.tmpFileName)
                do {
                    let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
                } catch {
                    print(error)
                }
        }
       print(ary)
    }
}


//MARK: - 返回Json数据
routes.add(method: .get, uri: "/json") { (reqeust, response) in
    let dic: [String : Any] = ["key1": "value1",
                               "key2": ["item1", 2, 3],
                               "key3": 3]
    response.setHeader(.contentType, value: "application/json")
    do {
        try response.setBody(json: dic)
    } catch {
        print("json转换失败")
    }
    response.completed()
}



//MARK: - Request——Redirect
routes.add(method: .get, uri: "/redirect") { (reqeust, response) in
    response.status = .movedPermanently
    response.setHeader(HTTPResponseHeader.Name.location, value: "http://cnblogs.com")
    response.completed()
}



//MARK: - 通过过滤器定制404页面风格
struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.bodyBytes.removeAll()
            response.setBody(string: "<h1>404:The file \(response.request.path) was not found.</h1>")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        } else {
            callback(.continue)
        }
    }
}
server.setResponseFilters([(Filter404(), .high)])



//MARK: - 添加日志文件记录
LogFile.location = "./files/logs/myLog.log"     //设置日志文件路径
// 增加日志过滤器，将日志写入相应的文件
server.setRequestFilters([(RequestLogger(), .high)])    // 首先增加高优先级的过滤器
server.setResponseFilters([(RequestLogger(), .low)])    // 最后增加低优先级的过滤器

//LogFile.debug("调试")
//LogFile.info("消息")
//LogFile.warning("警告")
//LogFile.error("出错")
//LogFile.critical("严重错误")
//LogFile.terminal("服务器终止")


routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>你好!</title><body><h3>Hello, Swift-Perfect!</h3></body></html>")
    response.completed()
}
)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8888

// Set a document root.
// This is optional. If you do not want to serve static content then do not set this.
// Setting the document root will automatically add a static file handler for the route /**
server.documentRoot = "./webroot"

// Gather command line options and further configure the server.
// Run the server with --help to see the list of supported arguments.
// Command line arguments will supplant any of the values set above.
configureServer(server)

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}


