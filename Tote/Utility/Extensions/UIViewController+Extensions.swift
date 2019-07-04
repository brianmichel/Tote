//
//  UIViewController+Extensions.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildViewControllerCompletely(_ childViewController: UIViewController?, belowSubview subview: UIView? = nil, withParentView parentView: UIView? = nil) {
        guard let childViewController = childViewController else { return }

        childViewController.willMove(toParent: self)
        addChild(childViewController)

        guard let parentView = parentView ?? view else { return }

        if let subview = subview {
            parentView.insertSubview(childViewController.view, belowSubview: subview)
        } else {
            parentView.addSubview(childViewController.view)
        }

        childViewController.didMove(toParent: self)
    }

    func removeChildViewControllerCompletely(_ childViewController: UIViewController?) {
        guard let childViewController = childViewController else { return }
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.view.removeFromSuperview()
        childViewController.didMove(toParent: nil)
    }

    func removeFromParentViewControllerCompletely() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
        didMove(toParent: nil)
    }
}
