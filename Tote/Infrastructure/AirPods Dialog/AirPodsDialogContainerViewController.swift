//
//  AirPodsDialogContainerViewController.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

class AirPodsDialogContainerViewController: UIViewController {
    private enum Constants {
        static let iPhoneXCornerRadius: CGFloat = 35.0
        static let contentInsets = UIEdgeInsets(top: 5, left: 30, bottom: 25, right: 30)
        static let dismissButtonOffset = UIOffset(horizontal: 20, vertical: 20)
    }

    let presenter = AirPodsDialogSlideUpPresenter()

    private let contentViewController: UIViewController
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 5.0
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let dismissButton: UIButton = {
        let button = UIButton()
        let boldLargeConfig = UIImage.SymbolConfiguration(pointSize: UIFont.buttonFontSize, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.setPreferredSymbolConfiguration(boldLargeConfig, forImageIn: .normal)
        button.tintColor = .lightGray
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let header: UILabel = {
        let header = UILabel()
        header.font = UIFont.preferredFont(forTextStyle: .title1)
        header.textAlignment = .center

        return header
    }()

    override var preferredContentSize: CGSize {
        get {
            return super.preferredContentSize
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    init(viewController: UIViewController) {
        contentViewController = viewController
        super.init(nibName: nil, bundle: nil)

        preferredContentSize = CGSize(width: 0, height: 430)

        modalPresentationStyle = .custom
        transitioningDelegate = presenter

        addChild(contentViewController)

        dismissButton.addTarget(self, action: #selector(dismissDialog), for: .touchUpInside)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.iPhoneXCornerRadius
        view.layer.cornerCurve = .continuous

        let button = UIButton()
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8.0
        button.setTitle("Connect", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)

        header.text = contentViewController.title

        contentViewController.view.layer.cornerRadius = 8.0
        contentViewController.view.layer.masksToBounds = true
        contentViewController.view.backgroundColor = .darkGray

        contentStackView.addArrangedSubview(header)
        contentStackView.addArrangedSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        contentStackView.addArrangedSubview(button)

        view.addSubview(dismissButton)
        view.addSubview(contentStackView)

        contentStackView.backgroundColor = .green

        NSLayoutConstraint.activate([
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.dismissButtonOffset.horizontal),
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.dismissButtonOffset.vertical),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentInsets.left),
            contentStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: Constants.contentInsets.top),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.contentInsets.right),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.contentInsets.bottom),
        ])

        preferredContentSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        resetAppearance()
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        resetAppearance()
    }

    private func resetAppearance() {
        header.textColor = Colors.text.value
        view.backgroundColor = Colors.background.value
        view.layer.shadowColor = Colors.shadow.value.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.6
    }

    @objc private func dismissDialog() {
        dismiss(animated: true, completion: nil)
    }
}
