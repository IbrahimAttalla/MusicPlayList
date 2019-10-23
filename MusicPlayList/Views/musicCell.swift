//
//  musicCell.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit

class musicCell: UITableViewCell {

    @IBOutlet weak var songTitleLBL: UILabel!
    @IBOutlet weak var songTypeLBL: UILabel!
    @IBOutlet weak var songArtistLBL: UILabel!
    @IBOutlet weak var songIMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    /**
     ConfigCell : This method using to Display music Object per TableViewCell.
     
     by passsing the music object (song) to this func , then each view at this cell will set suitable date to show it in TableViewCell  .
     - returns:  the return value effect the  view   .
     
     */

    func ConfigCell(song:Music){
        self.songTitleLBL.text = song.title
        self.songTypeLBL.text = song.label
        self.songArtistLBL.text = song.mainArtist.name
        let imgUrl = URL(string: "https:\(song.cover.small!)")
        downloadImage(from: imgUrl!)
        
    }
    
    
    /**
     downloadImage : This method using to download image per TableViewCell.
     
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
