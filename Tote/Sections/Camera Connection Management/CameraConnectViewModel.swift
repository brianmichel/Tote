//
//  CameraConnectViewModel.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

protocol CameraConnectionViewModelDelegate: AnyObject {
    func didRequestConnection(for configuration: CameraConnectionConfiguration)
}

struct CameraConnectionConfiguration: Codable, Identifiable {
    let id: UUID
    let ssid: String
    let passphrase: String
    let nickname: String?

    internal init(id: UUID = UUID(), ssid: String, passphrase: String, nickname: String?) {
        self.id = id
        self.ssid = ssid
        self.passphrase = passphrase
        self.nickname = nickname
    }
}

final class CameraConnectViewModel: ObservableObject {
    @Published var title: String? = "Connect to camera"
    @Published var cameras = [CameraConnectionConfiguration]()

    private enum Constants {
        static let service = "me.foureyes.tote.connections"
    }

    private var storage = Set<AnyCancellable>()
    private let keychain = Keychain(service: Constants.service)

    weak var delegate: CameraConnectionViewModelDelegate?

    enum Action {
        case addNewConnection(configuration: CameraConnectionConfiguration)
        case removeConnection(configuration: CameraConnectionConfiguration)
        case connect(configuration: CameraConnectionConfiguration)
    }

    enum State {
        case initial
    }

    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()

    // MARK: Other Properties

    weak var viewController: UIViewController?

    init() {
        action.sink(receiveValue: { [weak self] action in
            self?.process(action: action)
        }).store(in: &storage)

        state.sink(receiveValue: { [weak self] state in
            self?.process(state: state)
        }).store(in: &storage)
    }

    private func process(action: Action) {
        switch action {
        case let .addNewConnection(configuration: configuration):
            keychain[configuration.id.uuidString] = configuration
            refreshConnections()
        case let .removeConnection(configuration: configuration):
            keychain.remove(valueFor: configuration.id.uuidString)
            refreshConnections()
        case let .connect(configuration: configuration):
            delegate?.didRequestConnection(for: configuration)
        }
    }

    private func process(state: State) {
        switch state {
        case .initial:
            refreshConnections()
        }
    }

    func refreshConnections() {
        let keys = keychain.allKeys

        cameras = keys.compactMap { (key) -> CameraConnectionConfiguration? in
            keychain[key]
        }
    }
}
