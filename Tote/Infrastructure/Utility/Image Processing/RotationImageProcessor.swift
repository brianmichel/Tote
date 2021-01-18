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
    var sourceOrientation: UIImage.Orientation = .up

    var description: String {
        return "RotationImageProcessor (com.foureyes.tote/imaging/rotation)"
    }

    public var identifier: String {
        return "com.foureyes.tote/imaging/rotation/source-orientation-\(sourceOrientation.rawValue)"
    }

    func process(_ image: PlatformImage) -> PlatformImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        let fixedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: sourceOrientation)
        return fixedImage
    }
}
