//
//  Decoder.swift
//  Tote
//
//  Created by Brian Michel on 3/31/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

extension CodingUserInfoKey {
    public static let decodingContext: CodingUserInfoKey! = CodingUserInfoKey(rawValue: "me.foureyes.tote.DecodingContext")
}

struct DecodingContext {
    var host: String
    var version: String
    var builder: APIURLBuilder
}

extension Decoder {
    var decodingContext: DecodingContext? {
        guard let context = userInfo[.decodingContext] as? DecodingContext else {
            return nil
        }

        return context
    }
}

extension JSONDecoder {
    convenience init(context: DecodingContext) {
        self.init()
        userInfo[.decodingContext] = context
    }
}
