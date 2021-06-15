//
//  GalleryLoader.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

public protocol GalleryLoader {
    typealias Result = Swift.Result<[GalleryItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
