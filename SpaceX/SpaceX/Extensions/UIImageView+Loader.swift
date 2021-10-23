//
//  UIImageView+Loader.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {

    @discardableResult
    func loadRemoteImageFrom(urlString: String, placeholder: UIImage?) -> URLSessionTask? {
        image = placeholder
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return nil
        }

        guard let url = URL(string: urlString) else { return nil }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let dataImage = data {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let imageToCache = UIImage(data: dataImage) {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    } else {
                        self.loadRemoteImageFrom(urlString: urlString, placeholder: placeholder)
                    }
                }
            }
        }
        task.resume()
        return task
    }
}
