//
//  HomeCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

final class HomeCoordinator: UISplitViewControllerDelegate {
    private let navigationViewController = UINavigationController(rootViewController: UITableViewController())
    private let splitViewController = UISplitViewController()
    private var currentRightPaneViewController: GalleryViewController = GalleryViewController()

    private let client = CameraAPI()

    init() {
        splitViewController.viewControllers = [navigationViewController, currentRightPaneViewController]
    }

    func start(on viewController: UIViewController) {
        viewController.present(splitViewController, animated: false, completion: nil)

        _ = client.photos { [weak self] result in
            switch result {
            case let .success(response):
                print("Got a response! \(response)")

                DispatchQueue.main.async {
                    self?.currentRightPaneViewController.folder = response.folders.first
                }
            case let .failure(error):
                print("Got an error: \(error)")
            }
        }
    }
}
