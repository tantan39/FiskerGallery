//
//  GalleryItemsMapper.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

final class GalleryItemsMapper {
    private struct Root: Decodable {
        var array: [RemoteGalleryItem]
    }
    
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [RemoteGalleryItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
             throw RemoteGalleryLoader.Error.invalidData
        }
        
        return root.array
    }
}
