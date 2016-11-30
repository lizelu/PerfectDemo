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

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()

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
routes.add(method: .get, uri: "/params") { (reqeust, response) in
    print("GET:\(reqeust.params())")
    response.appendBody(string: "GET请求参数：\(reqeust.params())")
    response.completed()
}

routes.add(method: .post, uri: "/params") { (reqeust, response) in
    print("POST:\(reqeust.params())")
    response.appendBody(string: "POST请求参数：\(reqeust.params())")
    response.completed()
}

routes.add(method: .put, uri: "/params") { (reqeust, response) in
    print("PUT:\(reqeust.params())")
    response.appendBody(string: "PUT请求参数：\(reqeust)")
    response.completed()
}

routes.add(method: .delete, uri: "/params") { (reqeust, response) in
    print("DELETE:\(reqeust.params())")
    response.appendBody(string: "DELETE请求参数：\(reqeust)")
    response.completed()
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



//MARK: - 定制404页面风格
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


// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

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
