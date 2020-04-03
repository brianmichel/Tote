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
        static let sheetInsets = UIEdgeInsets(top: 0, left: 7, bottom: 7, right: 7)
    }

    let presenting: Bool

    lazy var wrappingScrollView: UIScrollView = {
        let view = AirPodsDialogPresentationWrappingScrollView(frame: .zero)
        return view
    }()

    init(presenting: Bool) {
        self.presenting = presenting

        super.init()
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
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

        wrappingScrollView.frame = containerView.bounds
        wrappingScrollView.addSubview(presentedControllerView)
        wrappingScrollView.contentSize = CGSize(width: 0, height: presentedControllerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height)

        let duration = transitionDuration(using: transitionContext)

        if presenting {
            presentedControllerView.frame = CGRect(origin: CGPoint(), size: presentedController.preferredContentSize)
            presentedControllerView.frame = offscreenRect(forPresentingView: presentedControllerView, containerView: containerView)
        }

        containerView.addSubview(wrappingScrollView)

        wrappingScrollView.contentOffset = .zero

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: [], animations: {
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

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
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
