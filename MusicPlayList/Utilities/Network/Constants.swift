//
//  Constants.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import Foundation

// API URl
 let APIURL = "http://staging-gateway.mondiamedia.com"
 let BASE_URL = "\(APIURL)"


// User Defaults
let TOKEN_KEY = "token"


// CompletionHandler
typealias getTokenCompleted = (_ token:String? , _ error:String?) -> ()
typealias getMusicCompleted = (_ token:[Music]? , _ error:String?) -> ()

// Header
let TOKEN_HEADER = ["Content-Type":"application/x-www-form-urlencoded" , "X-MM-GATEWAY-KEY":"Ge6c853cf-5593-a196-efdb-e3fd7b881eca"]
let BEARER_HEADER = [
    "Authorization":"\(NetworkService.instance.authToken)","Content-Type": "application/x-www-form-urlencoded"]
