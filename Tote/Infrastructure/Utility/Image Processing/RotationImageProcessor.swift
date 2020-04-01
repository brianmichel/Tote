//
//  RotationImageProcessor.swift
//  Tote
//
//  Created by Brian Michel on 4/1/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import CoreGraphics
import Foundation
import Nuke

struct RotationImageProcessor: ImageProcessing, Hashable, CustomStringConvertible {
    // TODO: This works, but the code is wrong
    var sourceOrientation: UIImage.Orientation = .up

    var description: String {
        return "RotationImageProcessor (com.foureyes.tote/imaging/rotation)"
    }

    func process(image: PlatformImage, context _: ImageProcessingContext?) -> PlatformImage? {
        guard let cgImage = image.cgImage else {
            return image.fix(orientation: sourceOrientation)
        }

        let fixedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: sourceOrientation)
        return fixedImage
    }

    public var identifier: String {
        return "com.foureyes.tote/imaging/rotation/source-orientation-\(sourceOrientation.rawValue)"
    }
}
