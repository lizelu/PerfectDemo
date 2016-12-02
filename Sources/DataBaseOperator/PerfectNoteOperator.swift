//
//  PerfectNoteOperator.swift
//  PerfectTemplate
//
//  Created by Mr.LuDashi on 2016/12/2.
//
//

import Foundation
import MySQL
import PerfectLogger
class PerfectNoteOperator {
    let dataBaseName = "perfect_note"
    
    var mysql: MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    
}
