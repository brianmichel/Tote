//
//  HomeCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Combine
import UIKit

final class HomeCoordinator: UISplitViewControllerDelegate {
    private let splitViewController = UISplitViewController()
    private let galleryViewController: GalleryViewController = GalleryViewController()
    private let navigationViewController: UINavigationController

    init() {
        navigationViewController = UINavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true

        galleryViewController.viewModel = GalleryViewModel()
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)
    }
}
