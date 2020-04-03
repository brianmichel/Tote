//
//  DeviceTypeValueBox.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct DeviceTypeValueBox<T>: SwitchableBox {
    var left: T
    var right: T

    var determiner: SwitchableBoxDeterminer = { (left, right) -> T in
        #if targetEnvironment(simulator)
            return left
        #else
            return right
        #endif
    }

    typealias LeftOrRightType = T

    init(simulator: T, device: T) {
        left = simulator
        right = device
    }
}
