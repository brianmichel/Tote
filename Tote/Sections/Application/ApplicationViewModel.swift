//
//  ApplicationViewModel.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import UIKit

final class ApplicationViewModel: CameraConnectionViewModelDelegate {
    private enum Constants {
        static let ricohCameraHost = "192.168.0.1"
    }

    // MARK: Combine View Model Properties

    enum State {
        case connectingToCamera
        case connectedToCamera
        case disconnected(Error?)
    }

    enum Action {
        case connectToCamera(configuration: CameraConnectionConfiguration)
    }

    private var storage = Set<AnyCancellable>()

    let state = CurrentValueSubject<State, Never>(.disconnected(nil))
    let action = PassthroughSubject<Action, Never>()

    // MARK: View Model Properties

    let galleryViewModel = GalleryViewModel(api: NetworkAPI.standard)
    let cameraConnectViewModel = CameraConnectViewModel()

    private var cameraConnection: WifiCameraConnection?

    // MARK: Other Properties

    weak var viewController: UIViewController?

    init() {
        cameraConnectViewModel.delegate = self

        action.sink(receiveValue: { [weak self] action in
            self?.process(action: action)
        }).store(in: &storage)

        state.sink(receiveValue: { [weak self] state in
            self?.process(state: state)
        }).store(in: &storage)
    }

    private func process(state: State) {
        switch state {
        case .connectingToCamera:
            break
        case .connectedToCamera:
            break
        case .disconnected:
            break
        }
    }

    private func process(action: Action) {
        switch action {
        case let .connectToCamera(configuration: configuration):
            connectToCamera(with: configuration)
        }
    }

    private func connectToCamera(with configuration: CameraConnectionConfiguration) {
        let connection = WifiCameraConnection(ssid: configuration.ssid, passphrase: configuration.passphrase, hostname: Constants.ricohCameraHost)
        connection.$state.sink { [weak self] state in
            switch state {
            case .connected:
                self?.state.send(.connectedToCamera)
                self?.galleryViewModel.action.send(.cameraConnected)
            case .disconnecting, .disconnected:
                self?.state.send(.disconnected(nil))
                self?.galleryViewModel.action.send(.clearData)
            case .unknown, .connecting:
                break
            case .error:
                break
            }
        }.store(in: &storage)

        state.send(.connectingToCamera)
        connection.connect()

        cameraConnection = connection
    }

    // MARK: CameraConnectionViewModelDelegate

    func didRequestConnection(for configuration: CameraConnectionConfiguration) {
        connectToCamera(with: configuration)
    }
}
