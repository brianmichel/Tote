//
//  GalleryViewController.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Combine
import UIKit

final class GalleryViewController: UIViewController,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDelegate,
    UICollectionViewDataSource {
    private enum Constants {
        static let interitemSpacing: CGFloat = 5
        static let lineSpacing: CGFloat = 5
        static let columns: CGFloat = 2
        static let contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    private let collectionView: UICollectionView
    private var storage = Set<AnyCancellable>()

    var viewModel: GalleryViewModel? {
        willSet {
            storage.removeAll()
        }
        didSet {
            viewModel?.$selectedFolder.assign(to: \.folder, on: self).store(in: &storage)
            viewModel?.$cellViewModels.assign(to: \.photoViewModels, on: self).store(in: &storage)
            viewModel?.$folders.sink(receiveValue: { [weak self] folders in
                if folders.count >= 2 {
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(self?.switchFolders))
                } else {
                    self?.navigationItem.rightBarButtonItem = nil
                }
            }).store(in: &storage)
        }
    }

    private var folder: Folder? {
        didSet {
            // collectionView.reloadData()
        }
    }

    private var photoViewModels: [GalleryCellViewModel]? {
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

        navigationItem.largeTitleDisplayMode = .always

        title = "Tote"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hack to make the large header not collapse
        view.addSubview(UIView())
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        collectionView.reloadData()
    }

    @objc private func switchFolders() {
        guard let selectedFolderTitle = viewModel?.selectedFolder?.name else {
            return
        }

        let title = "Switch from folder \(selectedFolderTitle)"
        let alert = UIAlertController(title: title, message: "There are multiple folders on this camera, do you want to switch?", preferredStyle: .actionSheet)

        viewModel?.folders.forEach { folder in
            let action = { [weak self] (_: UIAlertAction) -> Void in
                self?.viewModel?.action.send(.switchFolder(folderName: folder.name))
            }
            alert.addAction(UIAlertAction(title: folder.name, style: .default, handler: action))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - UICollectionView DataSource / Delegate

    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let viewModels = photoViewModels else {
            return 0
        }

        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier,
                                                          for: indexPath) as? GalleryCollectionViewCell,
            let viewModel = photoViewModels?[indexPath.item]
        else {
            return UICollectionViewCell()
        }

        cell.viewModel = viewModel

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        let widthSquare = (collectionView.bounds.width -
            (Constants.contentInset.left + Constants.contentInset.right +
                (Constants.columns * Constants.interitemSpacing)
            )
        ) / Constants.columns

        return CGSize(width: widthSquare, height: widthSquare)
    }
}
