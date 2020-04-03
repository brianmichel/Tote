//
//  ApplicationViewController.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//
import Combine
import UIKit

class TestViewController: UITableViewController {
    override init(style: UITableView.Style) {
        super.init(style: style)
        title = "Select Camera"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    override func numberOfSections(in _: UITableView) -> Int {
        1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    override func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: .zero)
        cell.textLabel?.text = "Hi"
        cell.separatorInset = .zero

        return cell
    }
}

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
        viewModel.$state.sink { [weak self] state in
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
        let viewController = AirPodsDialogContainerViewController(viewController: CameraConnectViewController(model: viewModel.cameraConnectViewModel))
        present(viewController, animated: true, completion: nil)
        return

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
