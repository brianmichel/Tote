//
//  HomeCoordinator.swift
//  Tote
//
//  Created by Brian Michel on 6/22/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import Combine
import UIKit

final class HomeCoordinator: UISplitViewControllerDelegate, GalleryViewControllerDelegate {
    private let splitViewController = UISplitViewController()
    private let galleryViewController: GalleryViewController = GalleryViewController()
    private let navigationViewController: UINavigationController

    private let API = NetworkAPI.standard

    private var storage = Set<AnyCancellable>()

    init() {
        navigationViewController = UINavigationController(rootViewController: galleryViewController)
        navigationViewController.navigationBar.prefersLargeTitles = true

        galleryViewController.delegate = self
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(navigationViewController)

        API.folders()
            .sink(receiveCompletion: { completion in
                Log.info("\(completion)")
            },
                  receiveValue: { [weak self] value in
                Log.debug(String(describing: value))
                self?.galleryViewController.folder = value.folders.first
            })
            .store(in: &storage)
    }

    // MARK: GalleryViewControllerDelegate

    func galleryViewController(contorller _: GalleryViewController, didRequestDetailsFor mediaGroup: MediaGroup, in cell: GalleryCollectionViewCell) {
        guard let preferredFile = mediaGroup.preferredFile() else {
            return
        }

        API.specificPhotoInfo(folder: mediaGroup.folder, file: preferredFile.fileName).sink(receiveCompletion: { completion in
            Log.info("Completed loading photo info \(completion)")
        }, receiveValue: { response in
            Log.debug("Received response \(response)")
            DispatchQueue.main.async {
                cell.imageOrientation = UIImage.Orientation(rawValue: response.orientation - 1)!
                Log.debug("Got orientation of \(cell.imageOrientation.rawValue)")
                cell.imageURL = mediaGroup.thumbnailURL()
            }
        }).store(in: &storage)
    }
}
