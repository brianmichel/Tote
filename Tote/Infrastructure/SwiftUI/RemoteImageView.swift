//
//  RemoteImageView.swift
//  Tote
//
//  Created by Brian Michel on 8/4/21.
//  Copyright © 2021 Brian Michel. All rights reserved.
//

import Combine
import Nuke
import SwiftUI

final class ObservableRotatingImagePipeline: ObservableObject {
    @Published var image: UIImage?

    private let pipeline = ImagePipeline.shared
    private let url: URL

    init(url: URL, orientation: Int) {
        self.url = url

        let request = ImageRequest(url: url, processors: [
            RotationImageProcessor(sourceOrientation: UIImage.Orientation.remap(orientation: orientation)),
        ])

        pipeline.loadImage(with: request) { result in
            switch result {
            case let .success(response):
                self.image = response.image
            case let .failure(error):
                Log.error("There was an error loading the thumbnail for ObservableRotatingImagePipeline - \(error)")
            }
        }
    }
}

struct RemoteRotatingImageView: View {
    @ObservedObject private var loader: ObservableRotatingImagePipeline
    @State var image = UIImage()

    init(url: URL, orientation: Int) {
        loader = ObservableRotatingImagePipeline(url: url, orientation: orientation)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit).accessibilityIgnoresInvertColors(true)
        }.onReceive(loader.$image, perform: { image in
            if let image = image {
                self.image = image
            }
        })
    }
}
