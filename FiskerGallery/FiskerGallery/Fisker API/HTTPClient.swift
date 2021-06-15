//
//  HTTPClient.swift
//  FiskerGallery
//
//  Created by Tan Tan on 6/15/21.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(url: URL, completion: @escaping (Result) -> Void)
}
