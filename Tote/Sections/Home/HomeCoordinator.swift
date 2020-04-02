//
//  HomeCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Combine
import UIKit

class DarkModeAwareNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        updateBarTintColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateBarTintColor()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBarTintColor()
    }

    private func updateBarTintColor() {
        if #available(iOS 13.0, *) {
            self.navigationBar.barTintColor = Colors.background.value
        }
    }
}

final class HomeCoordinator: UISplitViewControllerDelegate {
    private let splitViewController = UISplitViewController()
    private let navigationViewController: UINavigationController

    private var storage = Set<AnyCancellable>()

    init(galleryViewModel: GalleryViewModel) {
        let galleryViewController = GalleryViewController(model: galleryViewModel)
        navigationViewController = DarkModeAwareNavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)
    }
}
