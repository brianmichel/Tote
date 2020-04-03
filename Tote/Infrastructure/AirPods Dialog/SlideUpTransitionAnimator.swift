//
//  SlideUpTransitionAnimator.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class SlideUpTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static let sheetInsets = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
    }

    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting

        super.init()
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresentation(transitionContext: transitionContext)
        } else {
            animateDismissal(transitionContext: transitionContext)
        }
    }

    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        let containerView = transitionContext.containerView

        let duration = transitionDuration(using: transitionContext)

        if presenting {
            presentedControllerView.frame = CGRect(origin: CGPoint(), size: presentedController.preferredContentSize)
            presentedControllerView.frame = offscreenRect(forPresentingView: presentedControllerView, containerView: containerView)
        }

        containerView.addSubview(presentedControllerView)

        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut], animations: {
            presentedControllerView.frame = self.onscreenRect(forPresentingView: presentedControllerView, containerView: containerView)
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }

    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        let containerView = transitionContext.containerView

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {
            presentedControllerView.frame = self.offscreenRect(forPresentingView: presentedControllerView, containerView: containerView)
        }, completion: { finished in
            presentedControllerView.removeFromSuperview()
            transitionContext.completeTransition(finished)
        })
    }

    private func offscreenRect(forPresentingView view: UIView, containerView: UIView) -> CGRect {
        let containerViewWidth = containerView.frame.width - Constants.sheetInsets.horizontal
        let rect = CGRect(x: Constants.sheetInsets.left,
                          y: containerView.frame.maxY,
                          width: containerViewWidth,
                          height: view.frame.height)

        return rect
    }

    private func onscreenRect(forPresentingView view: UIView, containerView: UIView) -> CGRect {
        let containerViewWidth = containerView.frame.width - Constants.sheetInsets.horizontal

        let rect = CGRect(x: Constants.sheetInsets.left,
                          y: containerView.frame.height - view.frame.height - Constants.sheetInsets.bottom,
                          width: containerViewWidth,
                          height: view.frame.size.height)

        return rect
    }
}
