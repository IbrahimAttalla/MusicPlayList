//
//  MusicListCellVM.swift
//  MusicPlayList
//
//  Created by it thinkers on 1/21/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class MusicListCellVM {
    
    let loadImg = LoadImage()
    var songImg = UIImage()

    var setImgToView:(()->())?
    var updateLoadingStatus: (()->())?

    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    let titleText: String
    let typeText: String
    let imageUrl: String
    let artistText: String

    init (titleText: String,typeText: String,imageUrl: String,artistText: String){
        self.titleText = titleText
        self.typeText = typeText
        self.imageUrl = imageUrl
        self.artistText = artistText
    }
    
    func fetchSongImg(songImgUrl:String){
        state = .loading

        let imgUrl = URL(string: "https:\(imageUrl)")
        loadImg.downloadImage(from: imgUrl!) {[weak self] (image) in
            
            guard let self = self  else{return}
            guard let newImage = image else{return}
            
            self.state = .populated
            self.songImg = newImage
            self.setImgToView?()
            self.updateLoadingStatus?()
        }
    }
}

