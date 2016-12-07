//
//  ContentReqest.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import Foundation
class ContentRequest: BaseRequest {
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
                guard let content = contentDetail["list"]! as? [String:String] else {
                    return
                }
                contentModel.content = content["content"] ?? ""
            }
            
            self.success(contentModel)
            
        }) { (errorMessage) in
            self.faile(errorMessage)
        }

        let params: [String:String] = ["contentId": contentId]
        request.postRequest(path: "\(requestPath)", parameters: params)
    }
    
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

}
