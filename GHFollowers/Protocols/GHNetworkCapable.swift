//
//  GHNetworkCapable.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/27/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

protocol GHNetworkCapable {
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void)
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void)
    func downloadImages(from urls: [URL])
    func cancelDownloadingImages(at urls: [URL])
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
