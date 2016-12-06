//
//  ContentDetailViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class ContentDetailViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    var content: ContentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCurrentVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configCurrentVC() {
        if content == nil {
            self.title = "添加笔记"
            self.submitButton.setTitle("添加", for: .normal)
        } else {
            self.title = "更新笔记"
            self.submitButton.setTitle("更新", for: .normal)
            self.titleTextField.text = content.title
            self.fetchContent()
        }
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
    }

}
