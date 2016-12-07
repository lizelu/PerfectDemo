//
//  ContentDetailViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit


/// 当前页面类型
///
/// - Add: 添加Note
/// - Update: 更新Note
enum ContentDetailType {
    case Add, Update
    func title() -> String {
        switch self {
        case .Add:
            return "添加"
        case .Update:
            return "更新"
        }
    }
}
typealias RefreshMainTableView = () -> Void
class ContentDetailViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    var updateMainVC : RefreshMainTableView!
    
    var content: ContentModel!
    var vcType: ContentDetailType = .Add
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCurrentVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Setter and Getter
    func setUpdateMainVC(update: @escaping RefreshMainTableView) {
        self.updateMainVC = update
    }
    
    //MARK: - Response Event
    @IBAction func tapGestrueRecognizer(_ sender: Any) {
        self.view.endEditing(true)
    }

    func tapSubmitButton(_ sender: Any) {
        if self.titleTextField.text == "" {
            Tools.showTap(message: "请输入标题", superVC: self)
            return
        }
        
        if self.contentTextView.text == "" {
            Tools.showTap(message: "请输入内容", superVC: self)
            return
        }
        if self.content == nil {
            self.content = ContentModel()
        }
        self.content.title = self.titleTextField.text!
        self.content.content = self.contentTextView.text!
        self.requestAddOrUpdate()
    }
    
    
    //MARK: - Private Method
    
    /// 添加分享按钮
    func addSubmitButton() {
        let barItem = UIBarButtonItem(title: self.vcType.title(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.tapSubmitButton(_:)))
        self.navigationItem.rightBarButtonItem = barItem
    }

    
    private func configCurrentVC() {
        self.addSubmitButton()
        if content == nil {
            self.vcType = .Add
        } else {
            self.vcType = .Update
            self.titleTextField.text = content.title
            self.fetchContent()
        }
        
        self.title = self.vcType.title()
    }
    
    
    /// 获取Note的内容
    private func fetchContent() {
        let listRequest = ContentRequest(start: {
        }, success: { (content) in
            DispatchQueue.main.async {
                guard let model = content as? ContentModel else {
                    return
                }
                self.content.content = model.content
                self.contentTextView.text = model.content
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
                Tools.showTap(message: errorMessage, superVC: self)
            }
        }
        
        print(self.content.contentId)
        listRequest.fetchContentDetail(contentId: self.content.contentId)
    }
    
    /// 添加或者请求更新
    private func requestAddOrUpdate() {
        switch self.vcType {
        case .Add:
            createAddOrUpdateRequestObj().contentAdd(model: self.content)
        case .Update:
            createAddOrUpdateRequestObj().contentUpdate(model: self.content)
        }
    }
    
    
    /// 创建添加或者请求对象
    ///
    /// - Returns:
    private func createAddOrUpdateRequestObj() -> ContentRequest {
        return ContentRequest(start: {
        }, success: { (content) in
            DispatchQueue.main.async {
                if self.updateMainVC != nil {
                    self.updateMainVC()
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
                Tools.showTap(message: errorMessage, superVC: self)
            }
        }
    }

}
