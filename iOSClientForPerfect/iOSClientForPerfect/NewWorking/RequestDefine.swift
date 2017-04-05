//
//  RequestPathDefine.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation

let LoginUserInfoKey = "LoginUserInfoKey"       //归档用户信息使用的key
let loginTokenKey = "key" //尚未实现，此Demo的二次登录先记录Password来实现

//与请求相关的定义
//let RequestHome = "http://10.10.146.198:8181"               //host
let RequestHome = "http://127.0.0.1:8888"               //host
let RequestUserInfoPath = "/queryUserInfoByUserName"    //通过用户名查询用户信息
let RequestUserLogin = "/login"                         //登录
let RequestUserRegister = "/register"                   //注册
let RequestContentList = "/contentList"                 //获取笔记列表
let RequestContentDetail = "/contentDetail"             //获取笔记详情
let RequestContentAdd = "/contentAdd"                   //添加笔记
let RequestContentUpdate = "/contentUpdate"             //更新笔记
let RequestContentDelete = "/contentDelete"             //删除笔记


