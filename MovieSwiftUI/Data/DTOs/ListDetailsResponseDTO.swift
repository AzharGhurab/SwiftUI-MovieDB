//
//  ListDetailsResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 04/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - List Details Response DTO

struct ListDetailsResponseDTO: Decodable {

    // MARK: - Properties

    let id: Int
    let name: String
    let description: String?
    let items: [MoviesPageResponseDTO.MovieDTO]?

    // MARK: - Mapping

    func toDomain() -> UserListDetails {
        UserListDetails(
            id: id,
            name: name,
            description: description ?? "",
            movies: (items ?? []).compactMap { $0.toDomain() }
        )
    }
}
