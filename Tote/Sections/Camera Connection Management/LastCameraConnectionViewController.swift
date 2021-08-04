//
//  LastCameraConnectionViewController.swift
//  Tote
//
//  Created by Brian Michel on 4/3/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class LastCameraConnectionViewController: UIViewController {
    private let viewModel: CameraConnectViewModel
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(model: CameraConnectViewModel) {
        viewModel = model
        super.init(nibName: nil, bundle: nil)

        title = "Choose camera"

        viewModel.viewController = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for camera in viewModel.cameras {
            let button = RoundedButton(icon: UIImage(systemName: "camera.circle.fill"), title: camera.nickname ?? camera.ssid)
            button.tintColor = .black
            button.backgroundColor = Colors.yellow
            button.didTap = { [weak self] _ in
                self?.viewModel.action.send(.connect(configuration: camera))
            }

            buttonStack.addArrangedSubview(button)
        }

        let button = RoundedButton(icon: UIImage(systemName: "plus.circle.fill"), title: "Add camera")
        button.tintColor = .black
        buttonStack.addArrangedSubview(button)

        let footer = UILabel()
        footer.font = UIFont.preferredFont(forTextStyle: .subheadline)
        footer.numberOfLines = 0
        footer.lineBreakMode = .byWordWrapping
        footer.textAlignment = .center
        footer.text = caption(for: viewModel.cameras)
        footer.preferredMaxLayoutWidth = view.bounds.width
        contentStack.addArrangedSubview(buttonStack)
        contentStack.addArrangedSubview(footer)

        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.pin(to: view),
            [
                view.heightAnchor.constraint(equalToConstant: contentStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height),
            ],
        ].flatMap { $0 })
    }

    private func caption(for cameras: [CameraConnectionConfiguration]) -> String {
        if cameras.count > 0 {
            return "Tap on a camera to connect, or tap add to connect to a new one."
        }

        return "Tap on add to create and connect to a new camera."
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
