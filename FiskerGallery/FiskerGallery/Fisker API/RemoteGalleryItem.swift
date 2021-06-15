//
//  RemoteGalleryItem.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

struct RemoteGalleryItem: Decodable {
    internal let id: UUID
    internal let author: String
    internal let url: URL
}
