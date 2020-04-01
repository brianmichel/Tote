//
//  PhotoInfoResponse.swift
//  Tote
//
//  Created by Brian Michel on 7/4/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import CoreMedia
import Foundation

struct CaptureInformation: Codable {
    let aperture: String
    let shutterSpeed: String
    let iso: String

    enum CodingKeys: String, CodingKey {
        case aperture = "av"
        case shutterSpeed = "tv"
        case iso = "sv"
    }
}

final class PhotoInfoResponse: Codable {
    let cameraModel: String
    let file: String
    let size: Int
    let datetime: String
    let orientation: Int
    let aspectRatio: String

    // let captureInformation: CaptureInformation

    enum CodingKeys: String, CodingKey {
        case cameraModel
        case file
        case size
        case datetime
        case orientation
        case aspectRatio
    }
}
