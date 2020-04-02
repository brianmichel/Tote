//
//  CameraConnection.swift
//  Tote
//
//  Created by Brian Michel on 4/1/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation
import NetworkExtension
import Reachability
import SystemConfiguration

enum CameraConectionState {
    case unknown
    case disconnecting
    case disconnected
    case connecting
    case connected
    case error(Error)
}

protocol CameraConnection {
    var state: CameraConectionState { get }
    func connect()
    func disconnect()
}

final class WifiCameraConnection: CameraConnection {
    @Published private(set) var state: CameraConectionState = .unknown

    private let reachability: Reachability
    private let configuration: NEHotspotConfiguration

    let ssid: String
    let passphrase: String

    init(ssid: String, passphrase: String, hostname: String) {
        self.ssid = ssid
        self.passphrase = passphrase

        configuration = NEHotspotConfiguration(ssid: ssid, passphrase: passphrase, isWEP: false)
        configuration.joinOnce = true

        do {
            reachability = try Reachability(hostname: hostname)
            reachability.whenReachable = { [weak self] reachability in
                Log.info("'\(hostname)' became reachable via \(reachability.connection.description).")
                self?.state = .connected
            }

            reachability.whenUnreachable = { [weak self] _ in
                Log.info("'\(hostname)' became unreachable.")
                self?.state = .disconnected
            }
        } catch {
            Log.error("Unable to create reachability checker, killing the application.")
            fatalError()
        }
    }

    func connect() {
        let manager = NEHotspotConfigurationManager.shared

        state = .connecting

        manager.apply(configuration) { [weak self] error in
            if let error = error {
                self?.state = .error(error)
                Log.error("Error apply hotspot configuration: - '\(error)'")
                self?.stopCheckingReachability()
            } else {
                self?.startCheckingReachability()
                Log.info("Successfully applied hotspot configuration")
            }
        }
    }

    func disconnect() {
        let manager = NEHotspotConfigurationManager.shared

        state = .disconnecting
        manager.removeConfiguration(forSSID: configuration.ssid)
    }

    private func startCheckingReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            Log.error("Unable to start Reachability notifier - \(error)")
        }
    }

    private func stopCheckingReachability() {
        reachability.stopNotifier()
    }
}
