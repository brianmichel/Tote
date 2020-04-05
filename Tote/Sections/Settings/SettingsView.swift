//
//  SettingsView.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    var dismiss: (() -> Void)?

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    NavigationLink(destination: SelectCameraConnectionView(addedConfiguration: { _ in }, selectedConfiguration: { _ in })) {
                        SettingsIconRow(image: UIImage(systemName: "camera")!, title: "Edit cameras")
                    }
                    NavigationLink(destination: AppIconsView()) {
                        SettingsIconRow(image: UIImage(systemName: "paintbrush")!, title: "Choose icon")
                    }
                }
                #if DEBUG
                    Section(header: Text("Debug")) {
                        SettingsIconRow(image: UIImage(systemName: "lock.shield")!, title: "Clear Keychain items")
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
            Spacer().frame(height: 10)
            HStack(spacing: 20) {
                Image(uiImage: image).renderingMode(.template)
                Text(title)
            }
            Spacer().frame(height: 10)
        }
    }
}

#if DEBUG
    struct SettingsViewPreviews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
#endif
