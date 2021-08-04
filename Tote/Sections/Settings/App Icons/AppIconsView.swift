//
//  AppIconsView.swift
//  Tote
//
//  Created by Brian Michel on 4/5/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import SwiftUI

struct AppIconGroup: Identifiable, Hashable {
    let id = UUID()
    let groupName: String
    let author: String = "Brian Michel"
    let lightImageName: String
    let darkImageName: String
}

struct AppIconsView: View {
    @State private var showDarkIcons: Bool = UITraitCollection.current.userInterfaceStyle == .dark

    private let icons = [
        AppIconGroup(groupName: "Mellow Yellow",
                     lightImageName: "AppIcon-Light-Default",
                     darkImageName: "AppIcon-Dark-Default"),
        AppIconGroup(groupName: "Blushing Basil",
                     lightImageName: "AppIcon-Light-Green",
                     darkImageName: "AppIcon-Dark-Green"),
        AppIconGroup(groupName: "Cold Cobalt",
                     lightImageName: "AppIcon-Light-Blue",
                     darkImageName: "AppIcon-Dark-Blue"),
        AppIconGroup(groupName: "Candy Apple Red",
                     lightImageName: "AppIcon-Light-Red",
                     darkImageName: "AppIcon-Dark-Red"),
    ]
    var body: some View {
        VStack {
            List {
                Section(footer: Text("Dark versions of each of the below icons are available, flip the toggle to see the dark versions.")) {
                    Toggle(isOn: $showDarkIcons, label: { Text("Show dark icons?") })
                }
                Section {
                    ForEach(icons, id: \.self) { icon in
                        AppIconGroupRow(group: icon, showDarkIcon: self.showDarkIcons).onTapGesture {
                            let iconName = self.showDarkIcons ? icon.darkImageName : icon.lightImageName
                            UIApplication.shared.setAlternateIconName(iconName) { error in
                                if let error = error {
                                    Log.error("Error selecting new app icon: - \(String(describing: error))")
                                }
                            }
                        }
                    }
                }

            }.listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
        }.navigationBarTitle(Text("Appearance"))
    }
}

struct AppIconGroupRow: View {
    var group: AppIconGroup
    var showDarkIcon: Bool = false

    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            HStack {
                Image(uiImage: UIImage(named: showDarkIcon ? group.darkImageName : group.lightImageName)!)
                    .mask(RoundedRectangle(cornerRadius: 12,
                                           style: .continuous))
                Spacer().frame(width: 20)
                VStack(alignment: .leading) {
                    Text(group.groupName).font(Font.system(.headline))
                    Text(group.author).font(Font.system(.subheadline))
                }
            }
            Spacer().frame(height: 10)
        }
    }
}

#if DEBUG
    struct AppIconsViewPreviews: PreviewProvider {
        static var previews: some View {
            AppIconsView()
        }
    }
#endif
