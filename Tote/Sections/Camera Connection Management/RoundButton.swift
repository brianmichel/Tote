//
//  RoundButton.swift
//  Tote
//
//  Created by Brian Michel on 4/3/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

final class RoundedButton: UIControl {
    private let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    var didTap: ((RoundedButton) -> Void)?

    private let titleLabel = UILabel()

    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.textColor = Colors.black
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        addGestureRecognizer(tap)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapButton() {
        didTap?(self)
    }
}
