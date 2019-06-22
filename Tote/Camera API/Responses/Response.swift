//
//  Response.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

class Response: Codable {
    var code: Int
    var message: String

    enum CodingKeys: String, CodingKey {
        case code = "errCode"
        case message = "errMsg"
    }
}
