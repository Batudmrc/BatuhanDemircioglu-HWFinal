//
//  ImageDownload.swift
//  
//
//  Created by Batuhan Demircioğlu on 7.06.2023.
//

import UIKit

extension NetworkManager {

    public func downloadImage(fromURL url: URL, completion: @escaping (UIImage?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("Image download error: \(error)")
                    completion(nil)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                completion(image)
            }
            task.resume()
        }

}
