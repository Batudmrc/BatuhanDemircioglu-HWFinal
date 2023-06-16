//
//  ImageDownload.swift
//  
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import UIKit

extension NetworkManager {

    public func downloadImageData(fromURL url: URL, completion: @escaping (Data?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Image download error: \(error)")
                    completion(nil)
                    return
                }
                completion(data)
            }
            task.resume()
        }

}
