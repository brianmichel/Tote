//
//  GalleryCollectionViewCell.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Combine
import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    let imageView = UIImageView()

    private var storage = Set<AnyCancellable>()
    var viewModel: GalleryCellViewModel? {
        willSet {
            storage.removeAll()
        }
        didSet {
            viewModel?.$thumbnailImage.assign(to: \.image, on: imageView).store(in: &storage)

            viewModel?.action.send(.loadMetadata)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 0.4

        contentView.addSubview(imageView)

        #if targetEnvironment(simulator)
            contentView.backgroundColor = .lightGray
        #endif

        resetAppearance()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        viewModel = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        resetAppearance()
    }

    private func resetAppearance() {
        imageView.layer.shadowColor = Colors.shadow.value.cgColor
    }
}
