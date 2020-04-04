//
//  UIView+NSLayoutConstrainHelpers.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

extension UIView {
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
        ]
    }

    func inset(byDeltaX deltaX: CGFloat?, andDeltaY deltaY: CGFloat?, inView view: UIView) -> [NSLayoutConstraint] {
        var trailingConstraint: NSLayoutConstraint?
        var leadingConstraint: NSLayoutConstraint?

        if let deltaX = deltaX {
            trailingConstraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -deltaX)
            leadingConstraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: deltaX)
        }

        var topConstraint: NSLayoutConstraint?
        var bottomConstraint: NSLayoutConstraint?

        if let deltaY = deltaY {
            topConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: deltaY)
            bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -deltaY)
        }

        return [
            trailingConstraint,
            leadingConstraint,
            topConstraint,
            bottomConstraint,
        ].compactMap { $0 }
    }

    func center(in view: UIView) -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]
    }

    func size(to size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
        ]
    }

    // https://gist.github.com/marcoarment/1105553afba6b4900c10
    func size(autoLayoutHeader targetWidth: CGFloat) -> CGSize {
        translatesAutoresizingMaskIntoConstraints = false
        let temporaryConstraint = widthAnchor.constraint(equalToConstant: targetWidth)

        addConstraint(temporaryConstraint)

        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        removeConstraint(temporaryConstraint)

        translatesAutoresizingMaskIntoConstraints = true

        return size
    }
}
