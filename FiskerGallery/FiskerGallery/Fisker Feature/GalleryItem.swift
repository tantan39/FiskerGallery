//
//  GalleryItem.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

public struct GalleryItem: Equatable {
    public let id: UUID
    public let author: String
    public let url: URL
    
    public init(id: UUID, author: String, url: URL) {
        self.id = id
        self.author = author
        self.url = url
    }
}
