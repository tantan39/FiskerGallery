//
//  GalleryItemCell+TestHelpers.swift
//  FiskerGalleryTests
//
//  Created by Tan Tan on 6/15/21.
//

import FiskerGallery

extension GalleryItemCell {
    var authorText: String {
        return authorLabel.text ?? ""
    }
    
    var urlText: String {
        return urlLabel.text ?? ""
    }
}
