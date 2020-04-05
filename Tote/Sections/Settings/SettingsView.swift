//
//  SettingsView.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Nuke
import SwiftUI

struct SettingsView: View {
    private let cameraViewModel = CameraConnectViewModel()

    var dismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: EditCameraConnectionsView(viewModel: cameraViewModel)) {
                        SettingsIconRow(image: UIImage(systemName: "camera")!, title: "Cameras")
                    }
                    NavigationLink(destination: AppIconsView()) {
                        SettingsIconRow(image: UIImage(systemName: "paintbrush")!, title: "Appearance")
                    }
                }
                #if DEBUG
                    Section(header: Text("Debug")) {
                        Button(action: {
                            Keychain().removeAllItems()
                        }) {
                            SettingsIconRow(image: UIImage(systemName: "lock.shield")!, title: "Clear Keychain items")
                        }
                        Button(action: {
                            Nuke.ImageCache.shared.removeAll()
                        }) {
                            SettingsIconRow(image: UIImage(systemName: "trash.circle")!, title: "Clear image cache")
                        }
                    }
                #endif
            }.listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular).navigationBarTitle(Text("Settings")).navigationBarItems(trailing: Button(action: {
                self.dismiss?()
                }, label: {
                    Text("Done")
            }))
        }
    }
}

struct SettingsIconRow: View {
    var image: UIImage
    var title: String

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(uiImage: image).renderingMode(.template)
                Text(title)
            }
        }.padding([.top, .bottom], 5)
    }
}

#if DEBUG
    struct SettingsViewPreviews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
#endif
