//
//  ApiURL.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import Foundation

public struct ApiURL {
    
    //main
    private let apiURL = "https://api.unsplash.com/"
    private let page = "page="
    private let accessKey = "&client_id=UkAo332eWPrezp1JVnGdfG3oANieDFuaj6s5DNKvVTM"
    //random
    private let photosRandom = "photos/random?"
    private let count = "&count=10"
    //search (with target)
    private let searchPhotos = "search/photos?"
    private let query = "&query="
    
    public func getRandomPhotosURLString(pageNumber: Int) -> String {
        let urlString = apiURL+photosRandom+page+"\(pageNumber)"+count+accessKey
        print("Loading from URL = \(urlString)")
        return urlString
    }
    
    public func getSearchPhotosURLString(target: String, pageNumber: Int) -> String {
        let urlString = apiURL+searchPhotos+page+"\(pageNumber)"+query+target+accessKey
        print("Loading from URL = \(urlString)")
        return urlString
    }
}

public enum UnsplashApi {
    static let host = "unsplash.com"
    static let callbackURLScheme = "fruktikApp://"
    static let clientID = Secrets.clientID
    static let clientSecret = Secrets.clientSecret
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
    static let tokenURL = "https://unsplash.com/oauth/token"
    static let redirectURL = "fruktikApp://unsplash"
}

extension UnsplashApi {
    enum Secrets {
        static let clientID = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_ID") ?? ""
        static let clientSecret = Secrets.environmentVariable(named: "UNSPLASH_CLIENT_SECRET") ?? ""

        private static func environmentVariable(named: String) -> String? {
            guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                print("Missing Environment Variable: '\(named)'")
                return nil
            }
            return value
        }
    }
}

