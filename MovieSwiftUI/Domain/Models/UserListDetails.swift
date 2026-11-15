//
//  UserListDetails.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - User List Details

struct UserListDetails: Equatable, Sendable {
    let id: Int
    let name: String
    let description: String
    let movies: [MovieSummary]
}
