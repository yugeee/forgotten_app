//
//  FareTableViewCell.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/12/11.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import UIKit

class FareTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var fareMastersPicker: UIPickerView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
    
    // yearsMonthsPickerの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // yearsMonthsPickerに表示する値の数
    func pickerView(_ fareMastersPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
     //yearsMonthsPickerに表示する値を返すデリゲートメソッド.
    func pickerView(_ fareMastersPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "error"
    }
    
    // pickerが選択された際に呼ばれるデリゲートメソッド.
    func pickerView(_ fareMastersPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    }
    
}
