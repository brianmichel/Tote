//
//  CameraConnectViewController.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

class CameraConnectViewController: UIViewController {
    let viewModel: CameraConnectViewModel
    private var storage = Set<AnyCancellable>()
    private var hostingViewController: UIHostingController<SelectCameraConnectionView>?

    init(model: CameraConnectViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)

        let selectionView = SelectCameraConnectionView(cameras: viewModel.cameras, addedConfiguration: { [weak self] configuration in
            self?.viewModel.action.send(.addNewConnection(configuration: configuration))
        }, selectedConfiguration: { [weak self] configuration in
            self?.viewModel.action.send(.connect(configuration: configuration))
        })

        hostingViewController = UIHostingController(rootView: selectionView)

        viewModel.viewController = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        resetAppearance()

        guard let hostingViewController = self.hostingViewController else {
            return
        }
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewControllerCompletely(hostingViewController)

        NSLayoutConstraint.activate(
            [
                hostingViewController.view.pin(to: view),
                [
                    view.heightAnchor.constraint(equalToConstant: 100),
                ],
            ].flatMap { $0 })
    }

    private func bind() {
        viewModel.$title.assign(to: \.title, on: self).store(in: &storage)

        if let view = self.hostingViewController?.rootView {
            viewModel.$cameras.assign(to: \.cameras, on: view).store(in: &storage)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        resetAppearance()
    }

    private func resetAppearance() {
        view.backgroundColor = Colors.background.value
    }
}
