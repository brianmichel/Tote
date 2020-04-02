//
//  ApplicationViewController.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//
import Combine
import UIKit

class ApplicationViewController: UIViewController {
    let viewModel: ApplicationViewModel

    private var storage = Set<AnyCancellable>()

    init(model: ApplicationViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)
        viewModel.viewController = self
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        bind()
    }

    private func bind() {
        viewModel.state.sink { [weak self] state in
            switch state {
            case .disconnected:
                self?.showConnectionDialog()
            case .connectingToCamera:
                self?.dismiss(animated: true, completion: nil)
            case .connectedToCamera:
                break
            }
        }.store(in: &storage)
    }

    private func showConnectionDialog() {
        let navigationController = DarkModeAwareNavigationController(rootViewController: CameraConnectViewController(model: viewModel.cameraConnectViewModel))
        present(navigationController, animated: true, completion: nil)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Since we're much more constrained on iPhone, limit the orientation to just portait.
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [.all]
        } else {
            return [.portrait]
        }
    }
}
