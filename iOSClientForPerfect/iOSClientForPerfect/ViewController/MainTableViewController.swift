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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.fetchList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        listRequest.fetchContentList(userId: AccountManager.share().userInfo.userId)
    }
    
    @IBAction func tapLoginOutButton(_ sender: Any) {
        self.dismiss(animated: true) {
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContentDetailViewController") as? ContentDetailViewController else {
            return
        }
        vc.content = self.contents[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
