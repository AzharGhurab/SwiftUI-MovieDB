//
//  UserList.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - User List

struct UserList: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let description: String
    let itemCount: Int
    let posterPath: String?
    let updatedAt: Date?

    // MARK: - Poster URL

    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)")
    }
}
