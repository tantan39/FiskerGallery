//
//  GalleryItemCelModel.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 6/16/21.
//

import FiskerGallery
import UIKit
public class GalleryItemCelModel {
    
    @Published private(set) var author: String?
    @Published private(set) var url: String?
    @Published private(set) var image: UIImage?
    
    public init(item: GalleryItem?) {
        guard let item = item else { return }
        author = item.author
        url = item.url
        image = UIImage(named: "placeholder")
    }
    
    func setImage(image: UIImage?) {
        self.image = image
    }
}
