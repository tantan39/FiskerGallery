//
//  GalleryItemsMapper.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

final class GalleryItemsMapper {

    static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemoteGalleryItem] {
        guard response.statusCode == 200, let items = try? JSONDecoder().decode([RemoteGalleryItem].self, from: data) else {
             throw RemoteGalleryLoader.Error.invalidData
        }
        
        return items
    }
}
