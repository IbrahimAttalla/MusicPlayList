//
//  WebAPI.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let instance = NetworkService()

    let defaults = UserDefaults.standard

    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    
    
    /**
     getToken : This method get Token and save it Locally throught userDefaults.
    
     by fixed key  xxx that passed as a parametr Throught header key "X-MM-GATEWAY-KEY" , we can get the token that saved and will be used later allover the API for Authorization Process .
     - returns:  user Token for Authorization Process  .
     
     # Notes: #
     1. completionHandler return the token after decoding it .
     
     */
    func getToken(completion: @escaping getTokenCompleted) {
        
        guard let APIUrl = URL(string: BASE_URL+"/v0/api/gateway/token/client") else { return }
        let request = NSMutableURLRequest(url: APIUrl)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Ge6c853cf-5593-a196-efdb-e3fd7b881eca", forHTTPHeaderField: "X-MM-GATEWAY-KEY")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let dataResponse = data else { return }
            do {
                let decoder = JSONDecoder()
                let tokenObj = try decoder.decode(Token.self, from:
                    dataResponse)
                if let token = tokenObj.accessToken{
                    self.authToken = "Bearer \(token)"
                    completion(self.authToken,nil)
                }
            } catch let err {
                completion(nil,err.localizedDescription)
                print("Err", err)
            }
            
            }
            task.resume()
    }
    
    
    
    
    /**
     getMusicList : This method get music list throught API.
     
     by saved token  that passed as a parametr Throught header key "Authorization" , we can get the music list that will be presented in the view  .
     - returns:  music Array for Displaying Process  .
     
     # Notes: #
     1. completionHandler return the MusicList after decoding it .
     */
    func getMusicList(params :String, completion: @escaping getMusicCompleted) {
         var musicUrl = URLComponents(string: BASE_URL+"/v2/api/sayt/flat")
        musicUrl!.queryItems =  [URLQueryItem(name: "query", value: "\(params)")]
        var request = URLRequest(url: musicUrl!.url!)
        
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = BEARER_HEADER
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let dataResponse = data else { return }
            do {
                let decoder = JSONDecoder()
                let musicList = try decoder.decode([Music].self, from:dataResponse) 
                completion(musicList,nil)

            } catch let err {
                completion(nil,err.localizedDescription)
                print("Err", err)
            }
            
            }
        task.resume()
    }

}



