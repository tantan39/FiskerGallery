//
//  ImageLoaderManager.swift
//  FiskerGalleryiOS
//
//  Created by Tan Tan on 6/16/21.
//

import UIKit
import FiskerGallery

extension GalleryItem {
    var imageDownloadURL: URL? {
        let width = 200
        let url = "https://picsum.photos/id/\(id)/\(width)/\(width)"
        return URL(string: url)
    }
}

typealias ImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

final class ImageDownloadManager {
    private var completionHandler: ImageDownloadHandler?
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "fisker.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageDownloadManager()
    private init () {}
    
    func downloadImage(_ url: URL?, indexPath: IndexPath? = nil, size: String = "m", handler: @escaping ImageDownloadHandler) {
        self.completionHandler = handler
        guard let url = url else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
           self.completionHandler?(cachedImage, url, indexPath, nil)
        } else {
             /* check if there is a download task that is currently downloading the same image. */
            if let operations = (imageDownloadQueue.operations as? [LoaderOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                operation.queuePriority = .veryHigh
            }else {
                /* create a new task to download the image.  */
                let operation = LoaderOperation(url: url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.downloadHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    self.completionHandler?(image, url, indexPath, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    /* FUNCTION to reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
    func slowDownImageDownloadTaskfor (_ item: GalleryItem) {
        guard let url = item.imageDownloadURL else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [LoaderOperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
    
}
