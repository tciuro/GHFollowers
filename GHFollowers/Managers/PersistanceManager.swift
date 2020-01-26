//
//  PersistanceManager.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/26/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct PersistanceManager {
    
    static let shared = PersistanceManager()
    
    func addUserToFavorites(named username: String) {
        let defaults = UserDefaults.standard
        var followers = favoriteUsers()
        if !followers.contains(username) {
            followers.append(username)
            defaults.set(followers, forKey: GHUserDefaults.followers)
        }
    }
    
    func removeUserFromFavorites(named username: String) {
        let defaults = UserDefaults.standard
        var followers = favoriteUsers()
        if followers.contains(username) {
            followers = followers.filter { $0 != username }
            defaults.set(followers, forKey: GHUserDefaults.followers)
        }
    }
    
    func favoriteUsers() -> [String] {
        let defaults = UserDefaults.standard
        let followers: [String] = defaults.object(forKey: GHUserDefaults.followers) as? [String] ?? []
        return followers
    }
    
}
