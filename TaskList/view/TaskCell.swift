//
//  TaskCell.swift
//  TaskList
//
//  Created by Moiz Khan on 2019-10-11.
//  Copyright © 2019 MK. All rights reserved.
//  Sheridan ID 9914774771 || UserName : khmoiz
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
