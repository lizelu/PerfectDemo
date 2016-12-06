//
//  MainPageCell.swift
//  iOSClientForPerfect
//
//  Created by Mr.LuDashi on 2016/12/6.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

import UIKit

class MainPageCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(content: ContentModel) {
        titleLabel.text = content.title
        timeLable.text = content.createTime
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
