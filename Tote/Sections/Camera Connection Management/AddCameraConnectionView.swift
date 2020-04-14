//
//  EditCameraConnectionView.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import SwiftUI

struct EditCameraConnectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    enum Style {
        case add
        case update
    }

    var id: UUID = UUID()
    @State var ssid: String = ""
    @State var passphrase: String = ""
    @State var nickname: String = ""

    var action: PassthroughSubject<CameraConnectViewModel.Action, Never>

    var style: Style = .add

    var body: some View {
        List {
            Section {
                TextField("SSID", text: $ssid)
                PasswordField(placeholder: "Passphrase", text: $passphrase)
                TextField("Nickname (optional)", text: $nickname)
                Button(action: {
                    self.action.send(.addNewConnection(configuration: self.createConfiguration()))
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text(buttonTitle(for: style)).frame(alignment: .center).disabled(ssid.isEmpty || passphrase.isEmpty) })
            }

            if style == .update {
                Button(action: {
                    self.action.send(.removeConnection(configuration: self.createConfiguration()))
                    self.presentationMode.wrappedValue.dismiss()
                }, label: { Text("Remove camera").accentColor(Color.red) })
            }
        }.modifier(AdaptsToKeyboard())
            .navigationBarTitle(Text("Camera information"))
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
    }

    private func createConfiguration() -> CameraConnectionConfiguration {
        return CameraConnectionConfiguration(id: id,
                                             ssid: ssid,
                                             passphrase: passphrase,
                                             nickname: nickname.isEmpty ? nil : nickname)
    }

    private func buttonTitle(for style: Style) -> String {
        switch style {
        case .add:
            return "Add camera"
        case .update:
            return "Update camera"
        }
    }
}

#if DEBUG
    struct EditCameraConnectionViewPreviews: PreviewProvider {
        static var previews: some View {
            Group {
                EditCameraConnectionView(action: PassthroughSubject<CameraConnectViewModel.Action, Never>())
                EditCameraConnectionView(ssid: "GR_8080",
                                         passphrase: "sdss",
                                         nickname: "cool",
                                         action: PassthroughSubject<CameraConnectViewModel.Action, Never>(),
                                         style: .update)
            }
        }
    }
#endif
