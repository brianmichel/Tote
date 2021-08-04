//
//  PhotoDetailView.swift
//  Tote
//
//  Created by Brian Michel on 8/4/21.
//  Copyright © 2021 Brian Michel. All rights reserved.
//

import SwiftUI

struct PhotoMetadataView: View {
    var information: MediaInfo?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(information?.file ?? "Unknown File").font(Font.system(.headline, design: .monospaced))
            Label(information?.cameraModel ?? "Unknown Camera", systemImage: "camera").font(.footnote)
            Divider()
            HStack {
                PhotoDetailInformationCell(systemImage: "camera.aperture", text: "ƒ\(information?.aperture ?? "-")")
                Divider().frame(width: 10, height: 20)
                PhotoDetailInformationCell(systemImage: "aspectratio", text: information?.aspectRatio ?? "-")
                Divider().frame(width: 10, height: 20)
                PhotoDetailInformationCell(systemImage: "hare", text: information?.shutterSpeed ?? "-")
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12.0,
                                     style: /*@START_MENU_TOKEN@*/ .continuous/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(UIColor.systemGray4)))
    }
}

struct PhotoDetailInformationCell: View {
    var systemImage: String
    var text: String

    var body: some View {
        HStack {
            Spacer()
            Label(text, systemImage: systemImage).font(Font.system(.footnote, design: .monospaced))
            Spacer()
        }
    }
}

struct PhotoDetailView: View {
    var group: MediaGroup

    var body: some View {
        let information = information()

        VStack {
            Spacer()
            RemoteRotatingImageView(url: group.thumbnailURL()!, orientation: information?.orientation ?? 0)
            Spacer()
            PhotoMetadataView(information: information)
        }.padding()
    }

    private func information() -> MediaInfo? {
        guard let preferredFile = group.preferredFile() else {
            return nil
        }

        let information = group.metadata(for: preferredFile)

        return information
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(group: testData())
    }

    static func testData() -> MediaGroup {
        let mediaURL = MediaURL(base: URL(string: "https://192.168.0.1/1/p/r100/R9188210.jpg")!, fileName: "R9188210.jpg", folderName: "R100")

        let group = MediaGroup(files: [
            mediaURL,
        ],
        groupName: "R9188210",
        folder: "R100")

        let metadata = MediaInfo(cameraModel: "RICOH GR III",
                                 file: "R9188210.JPG",
                                 size: 14_498_783,
                                 datetime: "2019-06-22T12:24:51",
                                 orientation: 8,
                                 aspectRatio: "3:2",
                                 aperture: "4.0",
                                 shutterSpeed: "1.250",
                                 iso: "640")

        group.update(metadata: metadata, for: mediaURL)

        return group
    }
}
