//
//  DetailsVC.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    var interactor:Interactor? = nil

    @IBOutlet weak var songIMG: UIImageView!
    @IBOutlet weak var songTitleLBL: UILabel!
    @IBOutlet weak var songDetailsLBL: UILabel!
    @IBOutlet weak var songArtistLBL: UILabel!
    @IBOutlet weak var songDurationLBL: UILabel!
    
    var musicListCellMV : MusicListCellVM?{
        didSet{
            print("musicListCellMV  == >>  ", musicListCellMV)
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        disPlayData(musicListCellMV: musicListCellMV!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    //    showHelperCircle()
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: false)
    }
    
    
    /*
     @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
//            interactor.hasStarted = true
//            interactor.update(progress)

        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    */
    
    
    /*
    func showHelperCircle(){
        let center = CGPoint(x: view.bounds.width * 0.5, y: 100)
        let small = CGSize(width: 30, height: 30)
        let circle = UIView(frame: CGRect(origin: center, size: small))
        circle.layer.cornerRadius = circle.frame.width/2
        circle.backgroundColor = UIColor.white
        circle.layer.shadowOpacity = 0.8
        circle.layer.shadowOffset = CGSize()
        view.addSubview(circle)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.25,
            options: [],
            animations: {
                circle.frame.origin.y += 200
                circle.layer.opacity = 0
        },
            completion: { _ in
                circle.removeFromSuperview()
        }
        )
    }
    */
  
    /**
     disPlayData : This method using to Display music Object .
     
     by passsing the music object (song) to this func , then each view at this ViewController will set suitable date to show it   .
     - returns:  the return value effect the  view   .
     */

    func disPlayData(musicListCellMV:MusicListCellVM){
        songTitleLBL.text = musicListCellMV.titleText
        songDetailsLBL.text = musicListCellMV.typeText
        songArtistLBL.text = musicListCellMV.artistText
                    //            songIMG.image = musicListCellMV.
        
        musicListCellMV.setImgToView = { [weak self] () in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            self.songIMG.image = self.musicListCellMV!.songImg
                        }
                    }
        
        musicListCellMV.fetchSongImg(songImgUrl: musicListCellMV.imageUrl)
        
    }
    
}
