//
//  Tools.swift
//  iOSClientForPerfect
//
//  Created by ZeluLi on 2016/12/3.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit
class Tools: NSObject {
    static func showTap(message: String, superVC: UIViewController) {
        let alter = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "OK")
        alter.show()
    }
}
