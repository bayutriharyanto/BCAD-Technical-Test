//
//  NetworkService.swift
//  BcadSimpleMusicApp
//
//  Created by Bayu Triharyanto on 11/10/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

class NetworkService {
    static let shared = NetworkService()
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(term: String, completion: @escaping (Result<[Song], APIError>) -> Void) {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "country", value: "ID"),
            URLQueryItem(name: "media", value: "music")
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        let datatask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError(NSError(domain: "No Data", code: 0, userInfo: nil))))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(ITunesSearchResponse.self, from: data)
                let songs = searchResponse.results.map { Song(id: $0.trackId, title: $0.trackName, artist: $0.artistName, previewUrl: $0.previewUrl, artworkUrl: $0.artworkUrl100, collectionName: $0.collectionName) }
                completion(.success(songs))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        datatask.resume()
    }
}

