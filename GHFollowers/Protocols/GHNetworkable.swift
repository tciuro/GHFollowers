//
//  GHNetworkable.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/27/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

protocol GHNetworkable {
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> Void)
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void)
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}
