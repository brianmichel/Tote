//
//  GalleryCellViewModel.swift
//  Tote
//
//  Created by Brian Michel on 4/1/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import Foundation
import Nuke

final class GalleryCellViewModel {
    enum State {
        case initial
        case metadataLoading
        case metadataLoaded
        case thumbnailLoading
        case thumbnailLoaded
        case error(message: String)
    }

    enum Action {
        case loadMetadata
        case loadImageThumbnail
    }

    @Published var thumbnailImage: UIImage?

    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()

    var mediaGroup: MediaGroup
    private let api: API

    private var storage = Set<AnyCancellable>()

    init(mediaGroup: MediaGroup, api: API) {
        self.mediaGroup = mediaGroup
        self.api = api

        state.sink(receiveValue: { [weak self] state in
            self?.process(state: state)
        }).store(in: &storage)

        action.sink(receiveValue: { [weak self] action in
            self?.process(action: action)
        }).store(in: &storage)
    }

    private func process(state: State) {
        switch state {
        case .initial:
            break
        case .metadataLoading:
            break
        case .metadataLoaded:
            break
        case .thumbnailLoading, .thumbnailLoaded:
            break
        case let .error(message):
            Log.error("There was an error performing some action, \(message)")
        }
    }

    private func process(action: Action) {
        switch action {
        case .loadMetadata:
            guard let preferredFile = mediaGroup.preferredFile() else {
                Log.error("Unable to find preferredFile for group with name \(mediaGroup.groupName), discarding action \(action)")
                return
            }

            state.value = .metadataLoading

            api.specificPhotoInfo(folder: preferredFile.folderName, file: preferredFile.fileName).sink(receiveCompletion: { _ in
                //
            }, receiveValue: { [weak self] info in
                self?.mediaGroup.update(metadata: info, for: preferredFile)
                self?.state.value = .metadataLoaded

                self?.action.send(.loadImageThumbnail)
            }).store(in: &storage)
        case .loadImageThumbnail:
            guard
                let preferredFile = mediaGroup.preferredFile(),
                let metadata = mediaGroup.metadata(for: preferredFile),
                let imageURL = preferredFile.resized(to: .view)
            else {
                Log.error("Unable to find preferredFile for group with name \(mediaGroup.groupName), discarding action \(action)")
                return
            }

            let request = ImageRequest(url: imageURL, processors: [
                RotationImageProcessor(sourceOrientation: UIImage.Orientation.remap(orientation: metadata.orientation)),
            ])

            state.value = .thumbnailLoading

            ImagePipeline.shared.loadImage(with: request, queue: nil, progress: nil) { [weak self] result in
                switch result {
                case let .success(response):
                    self?.thumbnailImage = response.image
                    self?.state.value = .thumbnailLoaded
                case let .failure(error):
                    Log.error("There was an error loading the thumbnail for mediaGroup \(String(describing: self?.mediaGroup.groupName)) - \(error)")
                    self?.state.value = .error(message: error.localizedDescription)
                }
            }
        }
    }
}
