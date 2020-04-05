//
//  AddCameraConnectionView.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI
import UIKit

struct SelectCameraConnectionView: View {
    @State var cameras = [CameraConnectionConfiguration]()

    var addedConfiguration: (CameraConnectionConfiguration) -> Void
    var selectedConfiguration: (CameraConnectionConfiguration) -> Void

    var body: some View {
        Form {
            Section(header: Text("Select previous camera")) {
                if cameras.count > 0 {
                    List(cameras) { configuration in
                        CameraConfigurationRow(configuration: configuration) { configuration in
                            self.selectedConfiguration(configuration)
                        }
                    }
                } else {
                    Text("No previous cameras")
                }
            }

            AddCameraConnectionView { ssid, passphase, nickname in
                self.addedConfiguration(CameraConnectionConfiguration(ssid: ssid, passphrase: passphase, nickname: nickname))
            }
        }.navigationBarTitle(Text("Cameras"))
    }
}

struct AddCameraConnectionView: View {
    @State private var ssid: String = ""
    @State private var passphrase: String = ""
    @State private var nickname: String = ""

    var addedConfiguration: (_ ssid: String, _ passphrase: String, _ nickname: String?) -> Void

    var body: some View {
        Section(header: Text("Add new camera")) {
            TextField("SSID", text: $ssid)
            SecureField("Passphrase", text: $passphrase)
            TextField("Nickname (optional)", text: $nickname)
            Button(action: {
                self.addedConfiguration(self.ssid, self.passphrase, self.nickname.isEmpty ? nil : self.nickname)
            }, label: { Text("Add camera").frame(alignment: .center).disabled(ssid.isEmpty || passphrase.isEmpty) })
        }
    }
}

struct CameraConfigurationRow: View {
    var configuration: CameraConnectionConfiguration

    var tappedConfiguration: (CameraConnectionConfiguration) -> Void

    var body: some View {
        if let nickname = configuration.nickname {
            return Button(action: { self.tappedConfiguration(self.configuration) }, label: { Text("\(nickname) (\(configuration.ssid))") })
        } else {
            return Button(action: { self.tappedConfiguration(self.configuration) }, label: { Text(configuration.ssid) })
        }
    }
}

#if DEBUG
    struct SelectCameraConnectionViewPreviews: PreviewProvider {
        static var previews: some View {
            SelectCameraConnectionView(cameras: [
                CameraConnectionConfiguration(ssid: "GR_34234", passphrase: "324234", nickname: "Brian's GR"),
                CameraConnectionConfiguration(ssid: "GR_0000", passphrase: "342111", nickname: nil),
            ], addedConfiguration: { _ in
                //
            }, selectedConfiguration: { _ in
                //
            })
        }
    }

    struct AddCameraConnectionViewPreviews: PreviewProvider {
        static var previews: some View {
            AddCameraConnectionView { _, _, _ in
                //
            }
        }
    }
#endif
