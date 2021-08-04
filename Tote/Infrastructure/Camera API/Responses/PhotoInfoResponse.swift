//
//  PhotoInfoResponse.swift
//  Tote
//
//  Created by Brian Michel on 7/4/19.
//  Copyright © 2019 Brian Michel. All rights reserved.
//

import CoreMedia
import Foundation

final class MediaInfo: Codable {
    internal init(cameraModel: String,
                  file: String,
                  size: Int,
                  datetime: String,
                  orientation: Int,
                  aspectRatio: String,
                  aperture: String,
                  shutterSpeed: String,
                  iso: String)
    {
        self.cameraModel = cameraModel
        self.file = file
        self.size = size
        self.datetime = datetime
        self.orientation = orientation
        self.aspectRatio = aspectRatio
        self.aperture = aperture
        self.shutterSpeed = shutterSpeed
        self.iso = iso
    }

    let cameraModel: String
    let file: String
    let size: Int
    let datetime: String
    let orientation: Int
    let aspectRatio: String
    let aperture: String
    let shutterSpeed: String
    let iso: String

    enum CodingKeys: String, CodingKey {
        case cameraModel
        case file
        case size
        case datetime
        case orientation
        case aspectRatio
        case aperture = "av"
        case shutterSpeed = "tv"
        case iso = "sv"
    }
}
