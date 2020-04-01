//
//  GalleryCollectionViewCell.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Nuke
import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    private let imageView = UIImageView()

    var imageOrientation: UIImage.Orientation = .up

    var imageURL: URL? {
        willSet {
            Nuke.cancelRequest(for: imageView)
        }
        didSet {
            if let url = imageURL {
                let request = ImageRequest(url: url, processors: [RotationImageProcessor(sourceOrientation: imageOrientation)])
                Nuke.loadImage(with: request, into: imageView)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit

        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]

        contentView.backgroundColor = .green

        contentView.addSubview(imageView)
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

        imageURL = nil
    }
}
