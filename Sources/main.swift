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
routes.add(method: .get, uri: "/c", handler: {
		request, response in
		StaticFileHandler(documentRoot: request.documentRoot).handleRequest(request: request, response: response)
	}
)

var api = Routes()
api.add(method: .get, uri: "/call1") { (request, response) in
    response.appendBody(string: "接口1")
    response.appendBody(string: "\n\(request.queryParams)")//http://localhost:8181/v1/call1?key1=value1&key2=value2&key3=value3
    response.completed()
}

api.add(method: .get, uri: "/call2") { (request, response) in
    response.appendBody(string: "接口2")
    response.appendBody(string: "连接客户端的IP:Port\(request.remoteAddress)")
    response.appendBody(string: "服务器的IP:Port\(request.serverAddress)")
    response.completed()
}

//路由变量
api.add(method: .get, uri: "/call3/{key}") { (request, response) in
    response.appendBody(string: "路由变量key = \(request.urlVariables["key"])")
    response.completed()
}

//路由通配符
api.add(method: .get, uri: "/call4/*/list") { (request, response) in
    response.appendBody(string: "路由通配符")
    response.completed()
}

//路由通配符
api.add(method: .get, uri: "/call5/**") { (request, response) in
    response.appendBody(string: "路由通配符key = \(request.urlVariables[routeTrailingWildcardKey])")
    response.completed()
}



//创建两个版本的路由
var apiV1 = Routes(baseUri: "/v1")
var apiV2 = Routes(baseUri: "/v2")

//将之前的路由表追加到相应的版本路由表中
apiV1.add(api)
apiV2.add(api)

//更新版本2中相应的路由函数
apiV2.add(method: .get, uri: "/call2") { (request, response) in
    response.appendBody(string: "Verson2: 接口2")
    response.completed()
}

//将创建好的路由添加到服务器路由上
routes.add(apiV1)
routes.add(apiV2)




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
