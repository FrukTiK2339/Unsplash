//
//  NetworkDataFetcher.swift
//  Unsplash
//
//  Created by Дмитрий Рыбаков on 05.09.2023.
//

import UIKit

struct User: Decodable {
    var name: String
    var location: String?
}

struct Post: Decodable {
    var id: String
    var createdAt: String
    var description: String?
    var likedByUser: Bool
    var urls: [String:String]
    var user: User
}

struct SearchPhotosResponse: Decodable {
    var results : [Post]
}

public class NetworkDataFetcher {
    
    func getRandomPhotos(pageNumber: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: ApiURL.shared.getRandomPhotosURLString(pageNumber: pageNumber)) else { return }
        print("Request for Random Photos \n URL: \(url.absoluteString)")
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            if let posts = self.decodeJSON(type:[Post].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } else {
                fatalError("invalid JSON")
            }
            
        }
        dataTask.resume()
    }
    
    func getSearchedPhotos(pageNumber: Int, target: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: ApiURL.shared.getSearchPhotosURLString(target: target, pageNumber: pageNumber)) else { return }
        print("Request for Searching Photos (\(target)) \n URL: \(url.absoluteString)")
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            if let response = self.decodeJSON(type: SearchPhotosResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            } else {
                fatalError("invalid JSON")
            }
        }
        dataTask.resume()
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
    public func sendPhotoReaction(id: String, isLiked: Bool) {
        guard let url = URL(string: ApiURL.shared.getLikePhotoRequestURLString(id: id)) else { return }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? "POST" : "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success task")
            }
            
        }
        task.resume()
    }
}
