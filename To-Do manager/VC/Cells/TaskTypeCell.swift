//
//  TaskTypeCell.swift
//  To-Do manager
//
//  Created by Nikolay Zhukov on 19.07.2023.
//

import UIKit

class TaskTypeCell: UITableViewCell {

    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var typeDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
