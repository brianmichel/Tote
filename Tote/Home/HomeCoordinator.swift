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

    private let API = NetworkAPI.local

    private var storage = Set<AnyCancellable>()

    init() {
        navigationViewController = UINavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)

        API.folders()
            .sink(receiveCompletion: { completion in
                print(completion)

            },
                  receiveValue: { [weak self] value in
                print(value)
                self?.galleryViewController.folder = value.folders.first
            })
            .store(in: &storage)
    }
}
