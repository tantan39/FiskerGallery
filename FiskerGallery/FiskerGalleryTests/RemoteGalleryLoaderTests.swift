//
//  RemoteGalleryLoaderTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest

protocol GalleryLoader {
    typealias Result = Result<[GalleryItem], Error>
    
    func load(completion: (Result) -> Void)
}

struct GalleryItem {
    let id: UUID
    let author: String
    let url: URL
}

class RemoteGalleryLoaderTests: XCTestCase {
    
}
