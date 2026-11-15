//
//  CreateListView.swift
//  MovieSwiftUI
//
//  Created by Azhar Ghurab on 01/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

import SwiftUI

// MARK: - Create List View

struct CreateListView: View {

    // MARK: - Properties

    @Binding var name: String
    @Binding var description: String

    let nameCounterText: String
    let descriptionCounterText: String
    let isNameAtLimit: Bool
    let isDescriptionAtLimit: Bool
    let canSave: Bool
    let isSaving: Bool
    let errorMessage: String?
    let onSave: () -> Void

    // MARK: - Focus

    private enum Field {
        case name
        case description
    }

    @FocusState private var focusedField: Field?

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                nameSection
                descriptionSection

                if let errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }

                saveButton
            }
            .padding(16)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.black.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
        .navigationTitle("New List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { focusedField = .name }
    }

    // MARK: - Name

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(
                title: "Name",
                counter: nameCounterText,
                isAtLimit: isNameAtLimit
            )

            TextField("List name", text: $name)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .description }
                .padding(14)
                .background(fieldBackground)
        }
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader(
                title: "Description (optional)",
                counter: descriptionCounterText,
                isAtLimit: isDescriptionAtLimit
            )

            TextEditor(text: $description)
                .focused($focusedField, equals: .description)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 120)
                .padding(10)
                .background(fieldBackground)
        }
    }

    // MARK: - Save Button

    private var saveButton: some View {
        Button(action: onSave) {
            Group {
                if isSaving {
                    ProgressView()
                } else {
                    Text("Create List")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .buttonStyle(.borderedProminent)
        .tint(AppTheme.accent)
        .disabled(!canSave)
    }

    // MARK: - Helpers

    private func sectionHeader(
        title: String,
        counter: String,
        isAtLimit: Bool
    ) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))

            Spacer()

            Text(counter)
                .font(.caption)
                .foregroundStyle(isAtLimit ? Color.red : Color.secondary)
        }
    }

    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CreateListView(
            name: .constant("Weekend Watchlist"),
            description: .constant(""),
            nameCounterText: "17/50",
            descriptionCounterText: "0/200",
            isNameAtLimit: false,
            isDescriptionAtLimit: false,
            canSave: true,
            isSaving: false,
            errorMessage: nil,
            onSave: {}
        )
    }
}
