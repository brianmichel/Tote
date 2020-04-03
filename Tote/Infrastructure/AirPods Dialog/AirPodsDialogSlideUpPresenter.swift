//
//  AirPodsDialogSlideUpPresenter.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class AirPodsDialogSlideUpPresenter: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source _: UIViewController) -> UIPresentationController? {
        return AirPodsDialogPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpTransitionAnimator(presenting: false)
    }

    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpTransitionAnimator(presenting: true)
    }
}
