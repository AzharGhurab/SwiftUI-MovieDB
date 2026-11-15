//
//  AccountDetailsResponseDTO.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 29/05/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//


import Foundation

// MARK: - Account Details Response DTO

struct AccountDetailsResponseDTO: Decodable {

    // MARK: - Properties

    let id: Int
    let name: String?
    let username: String
    let avatar: AvatarDTO?

    // MARK: - Account ID

    var accountID: Int {
        id
    }

    // MARK: - Avatar DTO

    struct AvatarDTO: Decodable {
        let gravatar: GravatarDTO?
        let tmdb: TMDBAvatarDTO?
    }

    struct GravatarDTO: Decodable {
        let hash: String?
    }

    struct TMDBAvatarDTO: Decodable {
        let avatarPath: String?
    }

    // MARK: - Mapping

    func toDomain() -> UserProfile {
        UserProfile(
            id: id,
            username: username,
            avatarURL: makeAvatarURL()
        )
    }

    private func makeAvatarURL() -> URL? {
        if let path = avatar?.tmdb?.avatarPath {
            return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
        }

        if let hash = avatar?.gravatar?.hash {
            return URL(string: "https://www.gravatar.com/avatar/\(hash)?s=200&d=404")
        }

        return nil
    }
}
