//
//  MusicListVM.swift
//  MusicPlayList
//
//  Created by it thinkers on 1/20/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit

class MusicListVM {
    
    
    
    let authGateway: APIAuthServiceProtocol
    let dataGateway : APIDataServiceProtocol
    
    private var music: [Music] = [Music]()
    
    // the concept for ViewModel all logic for evey view and VC shouldn't be in the same view but should to be seperatded , the view and VC for displaying only .
    
    // nots every view must have it's ViewModel not (each model have ViewModel) . so we build the next line ⤵︎⤵︎⤵︎
    private var cellViewModels: [MusicListCellVM] = [MusicListCellVM]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    
    var selectedMusic: Music?
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    // it's fired after get response from Token API
    var startFetchingMusicListClosure:(()->())?
    
    init( authGateway: APIAuthServiceProtocol = AuthGateway() , dataGateway :APIDataServiceProtocol = DataGetway() ) {
        self.authGateway = authGateway
        self.dataGateway = dataGateway
    }
   
    
    func initFetchToken() {
        state = .loading
        authGateway.fetchToken { [weak self] (success, token, error) in
            // [weak self] to avoid retain cycle and next guard let to avoid craching once self = nil when this view is closed or not available for some reason and this api completion handler get data , the some object that related to self will crahc the app if the reponse get while the view (self) not avialable yet .
            guard let self = self else {return}
            
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            // it not good to call some API func based on response of another 🤨🤨 but call this func in closure that fired after the 1st func response
            //  ⬇︎  fire closure with implementation at search VC, that call here at View Model  func to get music list 🤨🤨
            self.startFetchingMusicListClosure?()
            }
    }
    
    func fetchMusicList(searchText:String) {
        dataGateway.fetchMusicList(params: searchText) {  [weak self] (success,musiclist, error) in
            // [weak self] to avoid retain cycle and next guard let to avoid craching once self = nil when this view is closed or not available for some reason and this api completion handler get data , the some object that related to self will crahc the app if the reponse get while the view (self) not avialable yet .
            guard let self = self else {return}
            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            if musiclist != nil {
                self.processFetchedMusicList(musiclist: musiclist!)
                self.state = .populated
            }
        }
        
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MusicListCellVM {
        return cellViewModels[indexPath.row]
    }
    
    // be passed to cell for row
    func createCellViewModel( music: Music ) -> MusicListCellVM {
        
        //Wrap a description
//        var descTextContainer: [String] = [String]()
//        if let camera = photo.camera {
//            descTextContainer.append(camera)
//        }
//        if let description = photo.description {
//            descTextContainer.append( description )
//        }
//        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        return MusicListCellVM( titleText: music.title ?? "",
                                        typeText: music.type ?? "",
                                       imageUrl: music.cover.small ?? "",
                                       artistText: music.mainArtist.name ?? "")
    }
    
    
    // to load img
    private func processFetchedMusicList( musiclist: [Music] ) {
        self.music.removeAll()
        self.music = musiclist // Cache
        var vms = [MusicListCellVM]()
        for music in music {
            vms.append( createCellViewModel(music: music) )
        }
        self.cellViewModels = vms
    }
    

    
}

