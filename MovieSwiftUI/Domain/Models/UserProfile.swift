//
//  UserProfile.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - User Profile

struct UserProfile: Equatable, Sendable {
    let id: Int
    let username: String
    let avatarURL: URL?
}
