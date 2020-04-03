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
    static let text = AppearanceStyleBox<UIColor>(light: .black, dark: .white)
    static let background = AppearanceStyleBox<UIColor>(light: .white, dark: .black)
    static let shadow = AppearanceStyleBox<UIColor>(light: UIColor.black.withAlphaComponent(0.3),
                                                    dark: UIColor.white.withAlphaComponent(0.3))

    // Non-semantic colors
    static let yellow = UIColor(hex: "FFB700")!
    static let lightGray = UIColor(hex: "CCCCCC")!
}
