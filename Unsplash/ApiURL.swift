//
//  ApiURL.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import Foundation

public struct ApiURL {
    
    static let shared = ApiURL()
    
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
    
    //get user likes
    private let userLikedPhotos = "users/fruktik2339/likes"
    
    
    public func getRandomPhotosURLString(pageNumber: Int) -> String {
        return apiURL+photosRandom+page+"\(pageNumber)"+count+accessKey
    }
    
    public func getSearchPhotosURLString(target: String, pageNumber: Int) -> String {
        return apiURL+searchPhotos+page+"\(pageNumber)"+query+target+accessKey
    }
    
    public func getUserLikedPhotosURLString() -> String {
        return apiURL+userLikedPhotos+accessKey
    }
    
    //POST == like, DELETE == unlike
    public func getLikePhotoRequestURLString(id: String) -> String {
        return apiURL+"photos/\(id)/like"
        
    }
    
    
}
