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
import SystemConfiguration.CaptiveNetwork

enum CameraConnectionState {
    case unknown
    case disconnecting
    case disconnected
    case connecting
    case connected
    case error(Error)
}

protocol CameraConnection {
    var state: CameraConnectionState { get }
    // This is a hack until https://forums.swift.org/t/property-wrapper-requirements-in-protocols/33953 becomes a reality
    var statePublished: Published<CameraConnectionState> { get }
    var statePublisher: Published<CameraConnectionState>.Publisher { get }

    func connect()
    func disconnect()
}

final class SimulatorCameraConnection: ObservableObject, CameraConnection {
    @Published private(set) var state: CameraConnectionState = .unknown
    var statePublished: Published<CameraConnectionState> { return _state }
    var statePublisher: Published<CameraConnectionState>.Publisher { return $state }

    init() {
        // Do nothing
    }

    func connect() {
        state = .connecting
        state = .connected
    }

    func disconnect() {
        state = .disconnecting
        state = .disconnected
    }
}

final class WifiCameraConnection: ObservableObject, CameraConnection {
    @Published private(set) var state: CameraConnectionState = .unknown
    var statePublished: Published<CameraConnectionState> { return _state }
    var statePublisher: Published<CameraConnectionState>.Publisher { return $state }

    private let reachability: Reachability
    private let configuration: NEHotspotConfiguration
    private let queue = DispatchQueue(label: "me.foureyes.tote.WifiCameraConnection")

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
                let reallyConnected = self?.reallyConnected(to: ssid) ?? false
                if reallyConnected {
                    self?.state = .connected
                    Log.info("'\(hostname)' became reachable via \(reachability.connection.description).")
                } else {
                    self?.state = .disconnected
                }
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

    private func reallyConnected(to ssid: String) -> Bool {
        let ssidInformation = fetchSSIDInfo()
        guard let connectedSSID = ssidInformation["SSID"] as? String else {
            return false
        }

        return connectedSSID == ssid
    }

    private func fetchSSIDInfo() -> [String: Any] {
        var interface = [String: Any]()
        if let interfaces = CNCopySupportedInterfaces() {
            for index in 0 ..< CFArrayGetCount(interfaces) {
                let interfaceName = CFArrayGetValueAtIndex(interfaces, index)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                guard let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString) else {
                    return interface
                }
                guard let interfaceData = unsafeInterfaceData as? [String: Any] else {
                    return interface
                }
                interface = interfaceData
            }
        }
        return interface
    }
}
