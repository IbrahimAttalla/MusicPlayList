//
//  MusicList.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.



// To parse the JSON, add this file to your project and do:
//   let musicList = try? newJSONDecoder().decode(Music.self, from: jsonData)

import Foundation

// MARK: - Music
struct Music:Codable {
    var id :Int?
    var type :String?
    var title :String?
    var publishingDate :String?
    var duration :Int?
    var label :String?
    var mainArtist = Artist()
    var mainRelease :Bool?
    var streamableTracks :Int?
    var numberOfTracks :Int?
    var additionalArtists: [Artist]?
    var genres :[String]?
    var idBag = IDBag()
    var statistics = Statistics()
    var streamable :Bool?
    var partialStreamable :Bool?
    var adfunded :Bool?
    var bundleOnly :Bool?
    var cover = Cover()
    var variousArtists :Bool?

}


// MARK: - Artist
struct Artist: Codable {
    var id :Int?
    var name :String?
}


// MARK: - IDBag
struct IDBag: Codable {
    var ean: String?
    var upc: String?
    var icpn: String?
    var roviID: String?
    var roviReleaseID: String?
    
}

// MARK:- Statistics
struct Statistics: Codable {
    var popularity: Int?
    var estimatedRecentCount: Int?
    var estimatedTotalCount: Int?
    
}

// MARK: - Cover
struct Cover: Codable {
    var tiny: String?
    var small: String?
    var medium: String?
    var large: String?
    var coverDefault: String?
    var template: String?
}

struct Token: Codable {
    var accessToken: String?
    var tokenType: String?
    var expiresIn: String?

}


