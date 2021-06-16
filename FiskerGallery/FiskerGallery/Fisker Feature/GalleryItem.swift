//
//  GalleryItem.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

public struct GalleryItem: Equatable {
    public let id: String
    public let author: String
    public let url: String
    public let image: String
    
    public init(id: String, author: String, url: String, image: String) {
        self.id = id
        self.author = author
        self.url = url
        self.image = image
    }
}
