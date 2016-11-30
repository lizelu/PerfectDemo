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
routes.add(method: .get, uri: "/hello", handler: {
		request, response in
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>你好!</title><body>你好!</body></html>")
		response.completed()
	}
)

//返回图片
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

//获取请求参数: http://localhost:8181/params?key1=value1&key2=value2&key3=value3
routes.add(method: .get, uri: "/params") { (reqeust, response) in
    let params = reqeust.params()
    response.appendBody(string: "请求参数：\(reqeust.params())")
    response.completed()
}

//返回Json数据
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

//Request——Redirect
routes.add(method: .get, uri: "/redirect") { (reqeust, response) in
    response.status = .movedPermanently
    response.setHeader(HTTPResponseHeader.Name.location, value: "http://cnblogs.com")
    response.completed()
}

//定制404风格
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
