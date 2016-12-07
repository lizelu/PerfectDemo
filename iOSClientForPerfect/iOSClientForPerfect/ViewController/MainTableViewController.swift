//
//  MainTableViewController.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/5.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var contents: Array<ContentModel> = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.fetchList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Response Event
    @IBAction func tapLoginOutButton(_ sender: Any) {
        UserInfoRequest.loginOut()
        UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginVCNC")
    }

    @IBAction func tapRefreshButton(_ sender: Any) {
        self.fetchList()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContentDetailViewController") as? ContentDetailViewController else {
            return
        }
        vc.setUpdateMainVC {
            self.fetchList()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Private Method
    
    private func fetchList() {
        let listRequest = ContentRequest(start: {
        }, success: { (contents) in
            DispatchQueue.main.async {
                guard let list = contents as? Array<ContentModel> else {
                    return
                }
                self.contents = list
                self.tableView.reloadData()
            }
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
                Tools.showTap(message: errorMessage, superVC: self)
            }
        }
        listRequest.fetchContentList(userId: AccountManager.share().userId)
    }
    
    func deleteItem(contentId: String) {
        let deleteRequest = ContentRequest(start: {
        }, success: { (contents) in
            self.fetchList()
            
        }) { (errorMessage) in
            DispatchQueue.main.async {
                Tools.showTap(message: errorMessage, superVC: self)
            }
        }
        deleteRequest.contentDelete(contentId: contentId)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainPageCell", for: indexPath) as! MainPageCell
        cell.setContent(content: self.contents[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContentDetailViewController") as? ContentDetailViewController else {
            return
        }
        vc.content = self.contents[indexPath.row]
        vc.setUpdateMainVC {
            self.fetchList()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let contentId = self.contents[indexPath.row].contentId
        print(contentId)
        self.deleteItem(contentId: contentId)
    }
    
    

}
