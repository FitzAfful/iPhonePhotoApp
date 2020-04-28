//
//  VideoItem.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import RealmSwift

class VideoItem: Object, Codable, Identifiable {
    @objc var id: Int
    @objc var name: String
    @objc var thumbnail: String
    @objc var details: String
    @objc var videoLink: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail
        case details = "description"
        case videoLink = "video_link"
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

struct VideoResponse: Codable {
    var videos: [VideoItem]
}
