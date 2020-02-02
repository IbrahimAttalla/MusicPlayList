//
//  APIGateway.swift
//  MusicPlayList
//
//  Created by it thinkers on 1/21/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import Foundation


enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case noSimilarData = " no similar data founed "
    
}



protocol APIAuthServiceProtocol {
    func fetchToken( complete: @escaping ( _ success: Bool?, _ token:String?, _ error: APIError? )->() )
}

protocol APIDataServiceProtocol {
    func fetchMusicList( params:String, complete: @escaping ( _ success: Bool?, _ token:[Music]?, _ error: APIError? ) -> () )
}



// MARK:- AuthGateway class

class AuthGateway: APIAuthServiceProtocol {
    
    // this func will called at View Model
    func fetchToken(complete: @escaping (Bool?, String?, APIError?) -> ()) {
        
        guard let APIUrl = URL(string: BASE_URL+"/v0/api/gateway/token/client") else { return }
        let request = NSMutableURLRequest(url: APIUrl)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Ge6c853cf-5593-a196-efdb-e3fd7b881eca", forHTTPHeaderField: "X-MM-GATEWAY-KEY")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print(" 😎😎 token response ==>> " ,data )
            if error != nil {
                complete(false,nil,.serverOverload)
                print("Err", error)
            }
            
            guard let dataResponse = data else { return }
            do {
                let decoder = JSONDecoder()
                let tokenObj = try decoder.decode(Token.self, from:dataResponse)
                print(" 😎😎 token object ==>> " ,tokenObj )

                if let token = tokenObj.accessToken{
                    NetworkService.instance.authToken = "Bearer \(token)"
                    complete(true,NetworkService.instance.authToken,nil)
                }
            }
            catch let err {
//                complete(false,nil,.serverOverload)
                print("Err", err)
            }
        }
        task.resume()
    }
    

}




// MARK:- DataGetway class

class DataGetway: APIDataServiceProtocol {
    
    func fetchMusicList(params: String, complete: @escaping (Bool?, [Music]?, APIError?) -> ()) {
        var musicUrl = URLComponents(string: BASE_URL+"/v2/api/sayt/flat")
        musicUrl!.queryItems =  [URLQueryItem(name: "query", value: "\(params)")]
        var request = URLRequest(url: musicUrl!.url!)
        
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = BEARER_HEADER
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            print(" 😉😉 musicList response ==>> " ,data )

            if error != nil {
                complete(false,nil,.serverOverload)
                print("Err", error)
            }
            
            guard let dataResponse = data else { return }
            do {
                let decoder = JSONDecoder()
                 let musicList = try decoder.decode([Music].self, from:dataResponse)
            
                print(" 😉😉 musicList Arr ==>> \(musicList.count) item here    ... " ,musicList )

                complete(true,musicList,nil)
                
            }
            catch let err {
//                complete(false,nil,.noSimilarData)
                print("Err", err)
            }
        }
        task.resume()
    }
    
    
}

