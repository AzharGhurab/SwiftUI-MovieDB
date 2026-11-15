//
//  ListRowView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - List Row View

struct ListRowView: View {

    // MARK: - Properties

    let list: UserList

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            thumbnail

            VStack(alignment: .leading, spacing: 6) {
                Text(list.name)
                    .font(.title3)
                    .lineLimit(2)

                if !list.description.isEmpty {
                    Text(list.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(itemCountText)
                    .font(.body)
                    .foregroundStyle(.secondary)

                if let updatedText {
                    Text(updatedText)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Thumbnail

    private var thumbnail: some View {
        AsyncImage(url: list.posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            default:
                ZStack {
                    Color(.tertiarySystemFill)

                    Image(systemName: "photo.fill")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 72, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    // MARK: - Texts

    private var itemCountText: String {
        list.itemCount == 1 ? "1 item" : "\(list.itemCount) items"
    }

    private var updatedText: String? {
        guard let updatedAt = list.updatedAt else { return nil }
        return "Updated " + updatedAt.formatted(date: .abbreviated, time: .omitted)
    }
}

// MARK: - Preview

#Preview {
    List {
        NavigationLink(value: 0) {
            ListRowView(
                list: UserList(
                    id: 1,
                    name: "azhar",
                    description: "Test",
                    itemCount: 0,
                    posterPath: nil,
                    updatedAt: nil
                )
            )
        }
    }
    .listStyle(.plain)
    .preferredColorScheme(.dark)
}
