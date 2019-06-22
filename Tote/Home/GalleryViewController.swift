//
//  GalleryViewController.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import UIKit

final class GalleryViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate,
    UICollectionViewDataSource {
    private enum Constants {
        static let interitemSpacing: CGFloat = 5
        static let lineSpacing: CGFloat = 5
        static let columns: CGFloat = 4
        static let contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    private let collectionView: UICollectionView

    var folder: Folder? {
        didSet {
            collectionView.reloadData()
        }
    }

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.interitemSpacing
        layout.minimumLineSpacing = Constants.lineSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)

        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.contentInset = Constants.contentInset
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        collectionView.reloadData()
    }

    // MARK: - UICollectionView DataSource / Delegate

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let folder = folder else {
            return 0
        }

        return folder.files.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell,
            let folder = self.folder else {
            return UICollectionViewCell()
        }

        let imageURL = CameraV1APIEndpoints().specificPhoto(folder: folder.name, file: folder.files[indexPath.item], size: .view).request().url!

        cell.imageURL = imageURL

        cell.contentView.backgroundColor = .green
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        let widthSquare = (collectionView.bounds.width -
            (Constants.contentInset.left + Constants.contentInset.right +
                (Constants.columns * Constants.interitemSpacing))) / Constants.columns

        return CGSize(width: widthSquare, height: widthSquare)
    }
}
