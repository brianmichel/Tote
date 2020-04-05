//
//  TintAdjustingWindow.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class TintAdjustingWindow: UIWindow {
    var reactiveTintColor: AppearanceStyleBox<UIColor>? {
        didSet {
            if let tint = reactiveTintColor {
                tintColor = tint.value
            } else {
                tintColor = nil
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if let reactiveTintColor = reactiveTintColor {
            tintColor = reactiveTintColor.value
        }
    }
}
