//
//  SwitchableBox.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

protocol SwitchableBox {
    associatedtype LeftOrRightType

    typealias SwitchableBoxDeterminer = (LeftOrRightType, LeftOrRightType) -> LeftOrRightType

    var left: LeftOrRightType { get }
    var right: LeftOrRightType { get }
    var determiner: SwitchableBoxDeterminer { get }

    var value: LeftOrRightType { get }
}

extension SwitchableBox {
    var value: LeftOrRightType {
        return determiner(left, right)
    }
}
