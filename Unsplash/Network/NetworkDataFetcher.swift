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
    var profileImage: [String:String]
}

struct Post: Decodable, Hashable {
    var id: String
    var createdAt: String
    var description: String?
    var likedByUser: Bool
    var urls: [String:String]
    var user: User
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SearchPhotosResponse: Decodable {
    var results : [Post]
}

public class NetworkDataFetcher {
    
    private let apiURLs = ApiURL()
    
    func getRandomPhotos(pageNumber: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: apiURLs.getRandomPhotosURLString(pageNumber: pageNumber)) else { return }
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
        let formattedTarget = target.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: apiURLs.getSearchPhotosURLString(target: formattedTarget, pageNumber: pageNumber)) else { return }
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
}
