//
//  FareMasterTableViewCell.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2020/01/11.
//  Copyright © 2020 弓削直樹. All rights reserved.
//

import UIKit

class FareMasterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var purposeText: UITextField!
    
    @IBOutlet weak var transportationText: UITextField!
    
    
    @IBOutlet weak var departureText: UITextField!
    
    
    @IBOutlet weak var arrivalText: UITextField!
    
    @IBOutlet weak var roundTripSwitch: UISwitch!
    
    @IBOutlet weak var fareText: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
