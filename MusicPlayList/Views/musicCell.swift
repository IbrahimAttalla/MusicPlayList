//
//  musicCell.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//
import Foundation
import UIKit

class musicCell: UITableViewCell {

    @IBOutlet weak var loadingHud: UIActivityIndicatorView!
    
    @IBOutlet weak var songTitleLBL: UILabel!
    @IBOutlet weak var songTypeLBL: UILabel!
    @IBOutlet weak var songArtistLBL: UILabel!
    @IBOutlet weak var songIMG: UIImageView!
    
    // why if i set MusicListCellVM with out ? >>>  error the Class 'musicCell' has no initializers  🥺🥺
    var musicListCellMV : MusicListCellVM?{
        didSet{
            // to reset all views til loading a new one 
            songIMG.image = nil
            songTitleLBL.text = musicListCellMV?.titleText
            songTypeLBL.text = musicListCellMV?.typeText
            songArtistLBL.text = musicListCellMV?.artistText

                    print("Loading ...  " , musicListCellMV?.updateLoadingStatus)

            musicListCellMV!.updateLoadingStatus = { [weak self] () in
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch self.musicListCellMV!.state {
                    case .empty, .error:
                        self.loadingHud.stopAnimating()
                        self.loadingHud.isHidden = true
                    case .loading:
                        self.loadingHud.startAnimating()
                        self.loadingHud.isHidden = false
                    case .populated:
                        self.loadingHud.stopAnimating()
                        self.loadingHud.isHidden = true

                    }
                }
            }
            
            musicListCellMV!.setImgToView = { [weak self] () in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.songIMG.image = self.musicListCellMV!.songImg
                }
            }
            
            musicListCellMV!.fetchSongImg(songImgUrl: musicListCellMV!.imageUrl)

            
            }

        }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        print("Loading ...  " , musicListCellMV?.updateLoadingStatus)
//        musicListCellMV?.updateLoadingStatus = { [weak self] () in
//            guard let self = self else {
//                return
//            }
//
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                switch self.musicListCellMV!.state {
//                case .empty, .error:
//                    self.loadingHud.stopAnimating()
//                case .loading:
//                    self.loadingHud.startAnimating()
//                case .populated:
//                    self.loadingHud.stopAnimating()
//                }
//            }
//        }
//
//    }

    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    
    
    
    /**
     ConfigCell : This method using to Display music Object per TableViewCell.
     
     by passsing the music object (song) to this func , then each view at this cell will set suitable date to show it in TableViewCell  .
     - returns:  the return value effect the  view   .
     
     */

//    func ConfigCell(song:Music){
//        self.songTitleLBL.text = song.title
//        self.songTypeLBL.text = song.label
//        self.songArtistLBL.text = song.mainArtist.name
//        let imgUrl = URL(string: "https:\(song.cover.small!)")
//        downloadImage(from: imgUrl!)
//
//    }
    
    
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
