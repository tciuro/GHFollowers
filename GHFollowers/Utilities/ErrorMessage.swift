//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/11/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

enum ErrorMessage: String {
    case invalidUsername = "This username created an unvalid request. please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case failedToBuildFollowerList = "Unable to create the follower list. Please try again."
}
