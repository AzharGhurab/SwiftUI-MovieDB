//
//  SignInPromptView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Sign In Prompt View

struct SignInPromptView: View {

    // MARK: - Properties

    var title: String = "Sign in to use your lists"
    var message: String = "Sign in to TMDB to create and manage your lists."

    let isLoading: Bool
    let errorMessage: String?
    let onSignIn: () -> Void
    let onNotNow: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            icon
            
            Text(title)
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onSignIn) {
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign in with TMDB")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .disabled(isLoading)
            .padding(.top, 8)
            
            Button("Not now", action: onNotNow)
                .foregroundStyle(.primary)
                .disabled(isLoading)
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
                .fill(AppTheme.accent.opacity(0.15))
                .frame(width: 72, height: 72)

            Image(systemName: "lock.fill")
                .font(.title)
                .foregroundStyle(AppTheme.accent)
        }
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.opacity(0.6).ignoresSafeArea()

        SignInPromptView(
            isLoading: false,
            errorMessage: nil,
            onSignIn: {},
            onNotNow: {}
        )
    }
}
