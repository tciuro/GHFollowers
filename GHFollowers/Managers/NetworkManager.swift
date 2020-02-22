//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/11/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class NetworkManager: GHNetworkCapable {
    
    private var imageCache = NSCache<NSString, UIImage>()
    private var tasks = [String: URLSessionDataTask]()
    
    private var baseGitHubURL: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        return urlComponents
    }

    init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let url = _gitHubURL(with: "/users/\(username)/followers", query: ["per_page": "100", "page": String(page)]) else {
                completion(.failure(.invalidURL))
                return
        }
        
        _sendGHRequest(to: url, modelType: [Follower].self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        guard let url = _gitHubURL(with: "/users/\(username)") else {
            completion(.failure(.invalidURL))
            return
        }

        _sendGHRequest(to: url, modelType: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func downloadImages(from urls: [URL], size: CGSize) {
        for url in urls {
            downloadImage(from: url, size: size) { _ in }
        }
    }
    
    func cancelDownloadingImages(at urls: [URL]) {
        for url in urls {
            let urlString = url.absoluteString
            if let task = tasks[urlString] {
                if task.state != URLSessionTask.State.canceling {
                    task.cancel()
                    tasks[urlString] = nil
                }
            }
        }
    }
    
    func downloadImage(from url: URL, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let urlString = url.absoluteString
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let image = self.downsampleImage(at: url, size: size)
                
            DispatchQueue.main.async {
                if let image = image {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Private Section -
    
    private func _gitHubURL(with path: String, query: [String: String]? = nil) -> URL? {
        var urlComponents = baseGitHubURL
        urlComponents.path = path
        
        if let query = query {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in query {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
        }

        return urlComponents.url
    }
    
    private func _sendGHRequest<T: Codable>(to url: URL, modelType: T.Type, completion: @escaping (Result<T, GFError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.failedToDecodeResponse))
                return
            }
        }
        
        task.resume()
    }
    
    private func downsampleImage(at url: URL, size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        return UIHelper.downsample(imageAt: url, to: size, scale: scale)
    }
    
}
