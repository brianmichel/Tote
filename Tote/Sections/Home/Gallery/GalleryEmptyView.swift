//
//  GalleryEmptyView.swift
//  Tote
//
//  Created by Brian Michel on 4/3/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class GalleryEmptyView: UIView {
    private enum Constants {
        static let stackViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gr-camera"))
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(text: String) {
        super.init(frame: .zero)

        textLabel.text = text

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)

        addSubview(stackView)

        stackView.sizeToFit()

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackViewInsets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.stackViewInsets.right),
        ])

        resetAppearance()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        resetAppearance()
    }

    private func resetAppearance() {
        imageView.tintColor = Colors.text.value
        textLabel.tintColor = Colors.text.value
    }
}
