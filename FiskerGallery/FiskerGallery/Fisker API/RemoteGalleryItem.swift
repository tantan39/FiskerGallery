//
//  RemoteGalleryItem.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

struct RemoteGalleryItem: Decodable {
    internal let id: String
    internal let author: String
    internal let url: String
    internal let download_url: String
}
