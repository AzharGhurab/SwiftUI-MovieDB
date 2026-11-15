//
//  TVPageResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - TV Page Response

struct TVPageResponseDTO: Decodable {

    let page: Int
    let totalPages: Int
    let results: [TVDTO]

    struct TVDTO: Decodable {
        let id: Int
        let name: String?
        let posterPath: String?
        let voteAverage: Double?
        let genreIds: [Int]?
        let firstAirDate: String?
    }
}

// MARK: - Mapping to Domain

extension TVPageResponseDTO {

    func toDomain() -> MoviesPage {
        MoviesPage(
            movies: results.compactMap { $0.toDomain() },
            page: page,
            totalPages: totalPages
        )
    }
}

extension TVPageResponseDTO.TVDTO {

    func toDomain() -> MovieSummary? {
        guard let name, !name.isEmpty else { return nil }

        return MovieSummary(
            id: id,
            title: name,
            posterPath: posterPath,
            voteAverage: voteAverage ?? 0,
            genreIds: genreIds ?? [],
            releaseYear: String((firstAirDate ?? "").prefix(4)),
            mediaType: .tv
        )
    }
}
