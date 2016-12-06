//
//  ContentDetailViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

enum ContentDetailType {
    case Add, Update
    func title() -> String {
        switch self {
        case .Add:
            return "添加Note"
        case .Update:
            return "更新Note"
        }
    }
}
typealias RefreshMainTableView = () -> Void
class ContentDetailViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    var updateMainVC : RefreshMainTableView!
    
    var content: ContentModel!
    var vcType: ContentDetailType = .Add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCurrentVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpdateMainVC(update: @escaping RefreshMainTableView) {
        self.updateMainVC = update
    }
    
    func configCurrentVC() {
        if content == nil {
            self.vcType = .Add
        } else {
            self.vcType = .Update
            self.titleTextField.text = content.title
            self.fetchContent()
        }
        
        self.title = self.vcType.title()
        self.submitButton.setTitle(self.vcType.title(), for: .normal)
    }
    
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
        listRequest.fetchContentDetail(contentId: self.content.contentId)
    }

    
    @IBAction func tapGestrueRecognizer(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func tapSubmitButton(_ sender: Any) {
        
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
            self.content.title = self.titleTextField.text!
            self.content.content = self.contentTextView.text!
        }
        
        let request = ContentRequest(start: {
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
        
        switch self.vcType {
        case .Add:
            request.contentAdd(model: self.content)
        case .Update:
            request.contentUpdate(model: self.content)
        }

    }

}
