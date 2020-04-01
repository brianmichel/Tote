//
//  Colors.swift
//  Tote
//
//  Created by Brian Michel on 4/1/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

struct AppearanceModeBox<T> {
    let light: T
    let dark: T

    var value: T {
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark:
            return dark
        case .light:
            return light
        default:
            return light
        }
    }
}

enum Colors {
    static let text = AppearanceModeBox<UIColor>(light: .black, dark: .white)
    static let background = AppearanceModeBox<UIColor>(light: .white, dark: .black)
    static let shadow = AppearanceModeBox<UIColor>(light: .black, dark: .white)
}
