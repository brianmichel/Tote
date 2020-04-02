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
    private let galleryViewController: GalleryViewController = GalleryViewController()
    private let navigationViewController: UINavigationController

    private let cameraConnection: WifiCameraConnection = WifiCameraConnection(ssid: "GR_07CE90", passphrase: "10028121", hostname: "192.168.0.1")

    private var storage = Set<AnyCancellable>()

    init() {
        navigationViewController = DarkModeAwareNavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true

        cameraConnection.$state.sink { [weak self] state in
            switch state {
            case .connected:
                self?.galleryViewController.viewModel = GalleryViewModel()
            case .disconnecting, .disconnected:
                self?.galleryViewController.viewModel = nil
            case .unknown, .connecting:
                break
            case .error:
                break
            }
        }.store(in: &storage)
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)

        cameraConnection.connect()
    }
}
