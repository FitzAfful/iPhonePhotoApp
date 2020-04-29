//
//  DownloadVideoItem.swift
//  iPhonePhotoApp
//
//  Created by Fitzgerald Afful on 29/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import Foundation
import RealmSwift

class DownloadedVideo: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var downloadLocation: String = ""

    convenience init(id: Int, downloadLocation: String) {
        self.init()
        self.id = id
        self.downloadLocation = downloadLocation
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
