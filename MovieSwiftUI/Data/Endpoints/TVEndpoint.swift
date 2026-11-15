//
//  TVEndpoint.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import Foundation

// MARK: - TV Endpoint

enum TVEndpoint: APIEndpoint {

    case popular(page: Int)
    case search(query: String, page: Int)

    // MARK: - Path

    var path: String {
        switch self {
        case .popular:
            return "tv/popular"

        case .search:
            return "search/tv"
        }
    }

    // MARK: - Method

    var method: HTTPMethod {
        switch self {
        case .popular, .search:
            return .get
        }
    }

    // MARK: - Query Items

    var queryItems: [URLQueryItem] {
        switch self {
        case .popular(let page):
            return [URLQueryItem(name: "page", value: String(page))]

        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        }
    }
}
