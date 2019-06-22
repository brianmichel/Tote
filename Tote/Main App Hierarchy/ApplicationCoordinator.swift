//
//  ApplicationCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    private let window: UIWindow
    private let applicationViewController = ApplicationViewController()

    private let homeCoordinator = HomeCoordinator()

    init(window: UIWindow = UIWindow()) {
        self.window = window
    }

    func start() {
        window.rootViewController = applicationViewController
        window.makeKeyAndVisible()

        homeCoordinator.start(on: applicationViewController)
    }
}

