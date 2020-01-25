//
//  FareMasters.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/12/22.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import Foundation
class FareMaster: Codable {
    var fare_master_id: String = ""
    var user_id: String = ""
    var purpose: String = ""
    var transportation: String = ""
    var departure: String = ""
    var arrival: String = ""
    var round_trip: Int = 0
    var fare: Int = 0
}
