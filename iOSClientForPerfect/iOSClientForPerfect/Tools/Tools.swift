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
        let alter = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alter.show(superVC, sender: nil)
    }
}
