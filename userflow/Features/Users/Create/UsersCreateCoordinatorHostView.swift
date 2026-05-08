//
//  UsersCreateCoordinatorHostView.swift
//  userflow
//

import SwiftUI
import UIKit

/// Alta local (**`MT-10`**): formulario **`createLocalUser`** + validadores **`MT-09`**.
struct UsersCreateCoordinatorHostView: View {
    @StateObject private var viewModel: UsersCreateViewModel
    @Environment(\.dismiss) private var dismiss

    init(repository: UserRepository) {
        _viewModel = StateObject(wrappedValue: UsersCreateViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemGroupedBackground)
                .ignoresSafeArea()

            formContent
                .scrollContentBackgroundFinePrintIfAvailable()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.save { dismiss() }
                } label: {
                    Text(String(localized: String.LocalizationValue("users.detail.save")))
                        .font(.body.weight(.semibold))
                }
                .disabled(viewModel.isSaving)
            }
        }
    }

    @ViewBuilder
    private var formContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let banner = viewModel.saveErrorMessage {
                    HStack(alignment: .top, spacing: 10) {
                        Text(banner)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(String(localized: String.LocalizationValue("button.ok"))) {
                            viewModel.clearSaveError()
                        }
                        .buttonStyle(.borderless)
                        .foregroundColor(.accentColor)
                    }
                    .padding(12)
                    .background(Color(uiColor: .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 16)
                }

                groupedFieldCard(
                    titleKey: "users.create.section.profile",
                    fields: [
                        (key: "users.create.field.name", text: $viewModel.nameDraft, keyboard: .default, content: nil),
                        (key: "users.create.field.username", text: $viewModel.usernameDraft, keyboard: .default, content: .usernameAuto),
                    ]
                )

                groupedFieldCard(
                    titleKey: "users.create.section.contact",
                    fields: [
                        (key: "users.create.field.email", text: $viewModel.emailDraft, keyboard: .emailAddress, content: .emailAuto),
                        (key: "users.create.field.phone", text: $viewModel.phoneDraft, keyboard: .phonePad, content: nil),
                    ]
                )

                groupedFieldCard(
                    titleKey: "users.create.section.address",
                    fields: [
                        (key: "users.create.field.city", text: $viewModel.cityDraft, keyboard: .default, content: nil),
                    ]
                )

                Text(String(localized: String.LocalizationValue("users.create.footerHint")))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
            .padding(.top, 12)
            .opacity(viewModel.isSaving ? 0.55 : 1)
        }
        .disabled(viewModel.isSaving)
        .overlay {
            if viewModel.isSaving {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
    }

    private struct FieldSpec {
        enum TextContentKind {
            case usernameAuto
            case emailAuto
        }

        let key: String
        let text: Binding<String>
        let keyboard: UIKeyboardType
        let content: TextContentKind?
    }

    private func groupedFieldCard(titleKey: String, fields: [(key: String, text: Binding<String>, keyboard: UIKeyboardType, content: FieldSpec.TextContentKind?)]) -> some View {
        let specs = fields.map { FieldSpec(key: $0.key, text: $0.text, keyboard: $0.keyboard, content: $0.content) }
        return fieldCard(titleKey: titleKey, specs: specs)
    }

    private func fieldCard(titleKey: String, specs: [FieldSpec]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(titleKey))
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
                .padding(.leading, 4)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(specs.enumerated()), id: \.offset) { index, item in
                    labeledField(spec: item, showDividerBelow: index < specs.count - 1)
                }
            }
            .padding(.vertical, 4)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
            .padding(.horizontal, 16)
        }
    }

    private func labeledField(spec: FieldSpec, showDividerBelow: Bool) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(spec.key))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Group {
                    if #available(iOS 16.0, *) {
                        switch spec.content {
                        case .none:
                            legacyTextField(spec: spec)
                        case .some(.usernameAuto):
                            TextField("", text: spec.text)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .keyboardType(spec.keyboard)
                        case .some(.emailAuto):
                            TextField("", text: spec.text)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .keyboardType(spec.keyboard)
                        }
                    } else {
                        legacyTextField(spec: spec)
                    }
                }
                .font(.body)
                .accentColor(Color.accentColor)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if showDividerBelow {
                Divider()
                    .padding(.leading, 14)
            }
        }
    }

    /// iOS 15: **`textInputAutocapitalization`** / **`autocorrectionDisabled`** omitidos.
    private func legacyTextField(spec: FieldSpec) -> some View {
        TextField("", text: spec.text)
            .keyboardType(spec.keyboard)
            .autocapitalization(spec.content == nil ? .words : .none)
            .disableAutocorrection(spec.content != nil)
    }
}

// MARK: - iOS scroll background (suppress deprecated warning narrowly)

extension View {
    @ViewBuilder
    fileprivate func scrollContentBackgroundFinePrintIfAvailable() -> some View {
        if #available(iOS 16.0, *) {
            self.scrollDismissesKeyboard(.interactively)
        } else {
            self
        }
    }
}
