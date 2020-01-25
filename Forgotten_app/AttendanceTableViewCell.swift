//
//  AttendanceTableViewCell.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/10/11.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var summaryText: UITextField!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var restTimePicker: UIDatePicker!
    @IBOutlet weak var workTimePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
