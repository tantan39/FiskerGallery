//
//  RemoteGalleryLoaderTests.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import XCTest

protocol GalleryLoader {
    typealias Result = Swift.Result<[GalleryItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}

struct GalleryItem {
    let id: UUID
    let author: String
    let url: URL
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(url: URL, completion: @escaping (Result) -> Void)
}

struct RemoteGalleryLoader: GalleryLoader {
    let url: URL
    let client: HTTPClient
    
    func load(completion: (GalleryLoader.Result) -> Void) {
        
    }
}

class RemoteGalleryLoaderTests: XCTestCase {

}
