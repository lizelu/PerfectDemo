//
//  Package.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 4/20/16.
//	Copyright (C) 2016 PerfectlySoft, Inc.
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

import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	targets: [],
	dependencies: [
        //HTTPServer
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
		
		//Request请求日志过滤器
        .Package(url: "https://github.com/dabfleming/Perfect-RequestLogger.git",
                 majorVersion: 0),
        
        //将日志写入指定文件
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git",
                 majorVersion: 0, minor: 0),
        
        //MySql数据库依赖包
        .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git",
                 majorVersion: 2, minor: 0)
    ]
)
