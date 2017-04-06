//
//  ContentReqest.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation

/// 笔记相关请求
class ContentRequest: BaseRequest {
    
    
    /// 通过用户ID获取当前用户的Note列表
    ///
    /// - Parameter userId: 用户ID
    func fetchContentList(userId: String){
        let requestPath = "\(RequestHome)\(RequestContentList)"
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            guard let list = json as? [String: Any] else {
                return
            }
            
            var contents: Array<ContentModel> = []
            if list["list"] != nil {
                guard let contentList = list["list"]! as? [[String:String]] else {
                    return
                }
                
                for item in contentList {
                    let contentModels = ContentModel()
                    guard let contentId = item["contentId"] else {
                        continue
                    }
                    contentModels.contentId = contentId
                    
                    guard let title = item["title"] else {
                        continue
                    }
                    contentModels.title = title
                    
                    guard let time = item["time"] else {
                        continue
                    }
                    contentModels.createTime = time
                    contents.append(contentModels)
                }
            }
            
            self.success(contents)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["userId": userId]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    
    /// 获取笔记内容
    ///
    /// - Parameter contentId: 笔记ID
    func fetchContentDetail(contentId: String){
        let requestPath = "\(RequestHome)\(RequestContentDetail)"
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            guard let contentDetail = json as? [String: Any] else {
                return
            }
            let contentModel = ContentModel()
            if contentDetail["list"] != nil {
                guard let content = contentDetail["list"]! as? [String:Any] else {
                    return
                }
                contentModel.content = content["content"] as! String? ?? ""
            }
            
            self.success(contentModel)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        let params: [String:String] = ["contentId": contentId]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    
    /// 添加笔记
    ///
    /// - Parameter model: 笔记内容Model
    func contentAdd(model: ContentModel) {
        let requestPath = "\(RequestHome)\(RequestContentAdd)"
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            self.success(json)
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        
        let params: [String:String] = ["userId": AccountManager.share().userId,
                                       "title": model.title,
                                       "content": model.content]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    
    /// 更新笔记
    ///
    /// - Parameter model: 要更新笔记的Model 
    func contentUpdate(model: ContentModel) {
        let requestPath = "\(RequestHome)\(RequestContentUpdate)"
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            self.success(json)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        
        let params: [String:String] = ["contentId": model.contentId,
                                       "title": model.title,
                                       "content": model.content]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
    
    /// 删除当前记录
    ///
    /// - Parameter contentId: 当前ContentId
    func contentDelete(contentId: String) {
        let requestPath = "\(RequestHome)\(RequestContentDelete)"
        let request = Request(start: {
            self.start()
        }, success: { (json) in
            self.success(json)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }
        
        let params: [String:String] = ["contentId": contentId]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }


}
