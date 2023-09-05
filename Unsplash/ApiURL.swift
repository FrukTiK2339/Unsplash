//
//  ApiURL.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import Foundation

public struct ApiURL {
    
    static let shared = ApiURL()
    
    private let apiURL = "https://api.unsplash.com/"
    private let photosRandom = "photos/random?"
    private let searchPhotos = "search/photos?"
    private let page = "page="
    private let query = "&query="
    private let count = "&count=10"
    private let accessKey = "&client_id=UkAo332eWPrezp1JVnGdfG3oANieDFuaj6s5DNKvVTM"
    
    
    public func getRandomPhotosURL(pageNumber: Int) -> String {
        return apiURL+photosRandom+page+"\(pageNumber)"+count+accessKey
    }
    
    public func getSearchPhotosURL(target: String, pageNumber: Int) -> String {
        return apiURL+searchPhotos+page+"\(pageNumber)"+query+target+accessKey
    }
}
