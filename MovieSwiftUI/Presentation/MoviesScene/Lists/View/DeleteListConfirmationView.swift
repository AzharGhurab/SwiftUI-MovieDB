//
//  DeleteListConfirmationView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Delete List Confirmation View

struct DeleteListConfirmationView: View {

    // MARK: - Properties

    let listName: String
    let isDeleting: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            icon

            Text("Delete \"\(listName)\"?")
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)

            Text("This list and all its movies will be permanently deleted. This action cannot be undone.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: onConfirm) {
                Group {
                    if isDeleting {
                        ProgressView()
                    } else {
                        Text("Delete")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .disabled(isDeleting)
            .padding(.top, 8)

            Button("Cancel", action: onCancel)
                .foregroundStyle(.primary)
                .disabled(isDeleting)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .padding(.horizontal, 24)
        .environment(\.colorScheme, .dark)
    }

    // MARK: - Icon

    private var icon: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.15))
                .frame(width: 72, height: 72)

            Image(systemName: "trash")
                .font(.title)
                .foregroundStyle(.red)
        }
    }
}

// MARK: - Preview

#Preview {
    DeleteListConfirmationView(
        listName: "kenan",
        isDeleting: false,
        onConfirm: {},
        onCancel: {}
    )
    .preferredColorScheme(.dark)
}
