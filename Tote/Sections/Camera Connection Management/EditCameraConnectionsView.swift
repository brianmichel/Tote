//
//  AddCameraConnectionView.swift
//  Tote
//
//  Created by Brian Michel on 4/2/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Combine
import SwiftUI

struct AdaptsToKeyboard: ViewModifier {
    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.currentHeight)
                .animation(.easeOut(duration: 0.16))
                .onAppear(perform: {
                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
                        .compactMap { notification in
                            notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
                        }
                        .map { rect in
                            rect.height - geometry.safeAreaInsets.bottom
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
                        .compactMap { _ in
                            CGFloat.zero
                        }
                        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
                })
        }
    }
}

struct EditCameraConnectionsView: View {
    typealias CameraConnectionHandler = (CameraConnectionConfiguration) -> Void

    @ObservedObject var viewModel = CameraConnectViewModel()

    var body: some View {
        Form {
            Section(header: Text("Select previous camera")) {
                if viewModel.cameras.count > 0 {
                    List(viewModel.cameras) { configuration in
                        NavigationLink(destination: EditCameraConnectionView(id: configuration.id,
                                                                             ssid: configuration.ssid,
                                                                             passphrase: configuration.passphrase,
                                                                             nickname: configuration.nickname ?? "",
                                                                             action: self.viewModel.action,
                                                                             style: .update)) {
                            CameraConfigurationRow(configuration: configuration)
                        }
                    }
                } else {
                    Text("Previous cameras")
                }
            }

            Section {
                NavigationLink(destination: EditCameraConnectionView(action: self.viewModel.action)) {
                    Text("Add new camera")
                }
            }
        }
        .navigationBarTitle(Text("Cameras"))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct CameraConfigurationRow: View {
    var configuration: CameraConnectionConfiguration

    var tappedConfiguration: ((CameraConnectionConfiguration) -> Void)?

    var body: some View {
        if let nickname = configuration.nickname {
            return Button(action: { self.tappedConfiguration?(self.configuration) }, label: { Text("\(nickname) (\(configuration.ssid))") })
        } else {
            return Button(action: { self.tappedConfiguration?(self.configuration) }, label: { Text(configuration.ssid) })
        }
    }
}

#if DEBUG
    struct SelectCameraConnectionViewPreviews: PreviewProvider {
        static var previews: some View {
            let viewModel = CameraConnectViewModel()
            viewModel.cameras = [
                CameraConnectionConfiguration(ssid: "GR_34234", passphrase: "324234", nickname: "Brian's GR"),
                CameraConnectionConfiguration(ssid: "GR_0000", passphrase: "342111", nickname: nil),
            ]

            return EditCameraConnectionsView(viewModel: viewModel)
        }
    }
#endif
