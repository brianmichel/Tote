//
//  HomeCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

final class HomeCoordinator: UISplitViewControllerDelegate {
    private let splitViewController = UISplitViewController()
    private let galleryViewController: GalleryViewController = GalleryViewController()
    private let navigationViewController: UINavigationController

    init() {
        navigationViewController = UINavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true
    }

    private let client = CameraAPI()

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)

        _ = client.photos { [weak self] result in
            switch result {
            case let .success(response):
                print("Got a response! \(response)")

                DispatchQueue.main.async {
                    self?.galleryViewController.folder = response.folders.first
                }
            case let .failure(error):
                print("Got an error: \(error)")
            }
        }
    }
}
