//
//  Colors.swift
//  Tote
//
//  Created by Brian Michel on 4/1/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

struct AppearanceStyleBox<T>: SwitchableBox {
    var left: T
    var right: T

    var determiner: SwitchableBoxDeterminer = { (left, right) -> T in
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark:
            return right
        case .light:
            return left
        default:
            return left
        }
    }

    typealias LeftOrRightType = T

    init(light: T, dark: T) {
        left = light
        right = dark
    }
}

enum Colors {
    static let text = AppearanceStyleBox<UIColor>(light: Colors.black, dark: .white)
    static let background = AppearanceStyleBox<UIColor>(light: .white, dark: Colors.black)
    static let shadow = AppearanceStyleBox<UIColor>(light: Colors.black.withAlphaComponent(0.3),
                                                    dark: UIColor.white.withAlphaComponent(0.3))

    static let tint = AppearanceStyleBox<UIColor>(light: Colors.blue, dark: Colors.yellow)

    // Non-semantic colors
    static let black = UIColor(hex: "181515")!
    static let yellow = UIColor(hex: "FFB700")!
    static let blue = UIColor(hex: "00449E")!
    static let lightGray = UIColor(hex: "CCCCCC")!
}
