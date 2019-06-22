//
//  GalleryCollectionViewCell.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Kingfisher
import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    private let imageView = UIImageView()

    var imageURL: URL? {
        willSet {
            imageView.kf.cancelDownloadTask()
        }
        didSet {
            if let url = imageURL {
                imageView.kf.setImage(with: url)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFit

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
