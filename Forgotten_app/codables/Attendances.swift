//
//  Attendances.swift
//  Forgotten_app
//
//  Created by 弓削直樹 on 2019/08/15.
//  Copyright © 2019 弓削直樹. All rights reserved.
//

import Foundation

class Attendances: Codable {
    var work_time_total: String = ""
    var attendances: [Attendance]? = nil
}

class Attendance: Codable {
    var date: String       = ""
    var user_id: String    = ""
    var weekday: String    = ""
    var summary: String    = ""
    var holiday: Int    = 0
    var start_time: String = ""
    var end_time: String   = ""
    var rest_time: String  = ""
    var work_time: String  = ""
}
