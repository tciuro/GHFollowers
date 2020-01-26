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
    
    enum GHUserDefaults {
        static let followers = "followers"
    }

    func addFollowerToFavorites(_ follower: Follower) {
        var followers = favoriteFollowers()
        if !followers.contains(follower) {
            followers.append(follower)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(followers), forKey: GHUserDefaults.followers)
        }
    }
    
    func removeFollowerFromFavorites(_ follower: Follower) {
        var followers = favoriteFollowers()
        if followers.contains(follower) {
            followers = followers.filter { $0.login != follower.login }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(followers), forKey: GHUserDefaults.followers)
        }
    }
    
    func favoriteFollowers() -> [Follower] {
        if let data = UserDefaults.standard.value(forKey: GHUserDefaults.followers) as? Data {
            let followers = try? PropertyListDecoder().decode(Array<Follower>.self, from: data)
            return followers ?? []
        }
        return []
    }
    
}
