//
//  Result.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
