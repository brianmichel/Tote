//
//  AirPodsDialogPresentationController.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

class AirPodsDialogPresentationController: UIPresentationController {
    lazy var dimmingView: UIView = {
        let containerView = self.containerView ?? UIView()
        let view = UIView(frame: containerView.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()

    lazy var dimmingTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmerTapped))
        return gesture
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard
            let containerView = containerView
        else {
            return CGRect()
        }

        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = containerView.bounds
        frame = frame.insetBy(dx: 50.0, dy: 50.0)

        return frame
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard
            let containerView = containerView,
            let presentedView = presentedView
        else {
            return
        }

        dimmingView.addGestureRecognizer(dimmingTapGesture)

        dimmingView.frame = containerView.bounds
        containerView.addSubview(dimmingView)
        containerView.addSubview(presentedView)

        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext) -> Void in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext) -> Void in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    @objc private func dimmerTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
