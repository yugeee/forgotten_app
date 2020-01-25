//
//  Fares.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/12/08.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import Foundation
class Fares: Codable {
    var fare_total: Int = 0
    var fares: [Fare]? = nil
}

class Fare: Codable {
    var fare_id: String = ""
    var date: String = ""
    var user_id: String = ""
    var purpose: String = ""
    var transportation: String = ""
    var departure: String = ""
    var arrival: String = ""
    var round_trip: Int = 0
    var fare: Int = 0
}
