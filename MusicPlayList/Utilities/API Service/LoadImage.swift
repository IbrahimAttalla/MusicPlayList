//
//  LoadImage.swift
//  MusicPlayList
//
//  Created by it thinkers on 1/23/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit



class LoadImage{
    
    typealias getImageCompleted = (_ img:UIImage?) -> ()

    /**
     downloadImage : This method using to download image per TableViewCell.
     
     by passsing the image url to this func , then at main thread set the returnd data to iamge view to show it in TableViewCell  .
     - returns:  the return value effect the  ImageView   .
     
     */
    func downloadImage(from url: URL, completion: @escaping getImageCompleted) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("  📸 📸   image data  " , data)
            let image = UIImage(data: data)
            completion(image)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    
}
