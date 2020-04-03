//
//  LastCameraConnectionViewController.swift
//  Tote
//
//  Created by Brian Michel on 4/3/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class LabelEmbeddingView: UIView {
    private let embeddedLabel: UILabel

    init(label: UILabel) {
        embeddedLabel = label
        super.init(frame: .zero)

        embeddedLabel.translatesAutoresizingMaskIntoConstraints = false
        embeddedLabel.preferredMaxLayoutWidth = bounds.width

        addSubview(embeddedLabel)

        NSLayoutConstraint.activate(embeddedLabel.pin(to: self))
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class RoundedButton: UIControl {
    private let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let titleLabel = UILabel()

    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.text = title

        let imageView = UIImageView(image: icon)
        imageView.contentMode = .center
        imageView.preferredSymbolConfiguration = .init(pointSize: 35)

        verticalStack.addArrangedSubview(imageView)
        verticalStack.addArrangedSubview(titleLabel)

        addSubview(verticalStack)

        layer.cornerRadius = 20.0
        layer.cornerCurve = .continuous

        backgroundColor = Colors.lightGray

        NSLayoutConstraint.activate([
            verticalStack.pin(to: self, insets: UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)),
        ].flatMap { $0 })
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
            let button = RoundedButton(icon: UIImage(systemName: "camera.circle.fill"), title: camera.ssid)
            button.tintColor = .black
            button.backgroundColor = Colors.yellow
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

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
