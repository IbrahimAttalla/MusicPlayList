//
//  DetailsVC.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    var song:Music?
    
    @IBOutlet weak var songIMG: UIImageView!
    @IBOutlet weak var songTitleLBL: UILabel!
    @IBOutlet weak var songDetailsLBL: UILabel!
    @IBOutlet weak var songArtistLBL: UILabel!
    @IBOutlet weak var songDurationLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disPlayData(song: song!)
    }
    
    /**
     disPlayData : This method using to Display music Object .
     
     by passsing the music object (song) to this func , then each view at this ViewController will set suitable date to show it   .
     - returns:  the return value effect the  view   .
     */

    func disPlayData(song:Music){
        songTitleLBL.text = song.title
        songDetailsLBL.text = song.label
        songArtistLBL.text = song.mainArtist.name
        if let duration = song.duration {
            songDurationLBL.text = "\((duration/60))"
        }
        let imgUrl = URL(string: "https:\(song.cover.small!)")
        downloadImage(from: imgUrl!)
    }
    
    
    /**
     downloadImage : This method using to download image .
     
     by passsing the image url to this func , then at main thread set the returnd data to iamge view to show it in TableViewCell  .
     - returns:  the return value effect the  ImageView   .
     
     */
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.songIMG.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
