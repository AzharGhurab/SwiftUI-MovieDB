//
//  SearchRepository.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

protocol SearchRepository: Sendable {

    func search(
        query: String,
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage

    func popular(
        mediaType: MediaType,
        page: Int
    ) async throws -> MoviesPage
}
