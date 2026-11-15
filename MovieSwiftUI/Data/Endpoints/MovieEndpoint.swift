//
//  MovieEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 25/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - Movie Endpoint

enum MovieEndpoint: APIEndpoint {

    case list(category: MovieCategory, page: Int)
    case details(id: Int)
    case search(query: String, page: Int)

    // MARK: - Path

    var path: String {
        switch self {
        case .list(let category, _):
            return "movie/\(category.rawValue)"

        case .details(let id):
            return "movie/\(id)"

        case .search:
            return "search/movie"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .list, .details, .search:
            return .get
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem] {
        switch self {
        case .list(_, let page):
            return [URLQueryItem(name: "page", value: String(page))]

        case .details:
            return []

        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        }
    }
}
