//
//  UsersDetailCoordinatorHostView.swift
//  userflow
//

import SwiftUI
import UIKit

/// Detalle (**`MT-08`**): todos los campos del snapshot, avatar recurso por defecto, edición nombre/email en Realm (**`UserRepository.setLocalDisplayEdits`**).
struct UsersDetailCoordinatorHostView: View {
    @StateObject private var viewModel: UsersDetailViewModel

    init(localUserId: String, repository: UserRepository) {
        _viewModel = StateObject(wrappedValue: UsersDetailViewModel(localId: localUserId, repository: repository))
    }

    var body: some View {
        Group {
            if let loadIssue = viewModel.loadFailedMessage, viewModel.snapshot == nil {
                Spacer(minLength: 0)
                Text(loadIssue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                Spacer(minLength: 0)
            } else if let snapshot = viewModel.snapshot {
                detailScrollContent(snapshot: snapshot)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .navigationTitle(String(localized: String.LocalizationValue("users.detail.navigationTitle")))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if viewModel.isEditing {
                    Button(String(localized: String.LocalizationValue("button.cancel"))) {
                        viewModel.cancelEditing()
                    }
                    Button {
                        viewModel.saveEdits()
                    } label: {
                        Text(String(localized: String.LocalizationValue("users.detail.save")))
                            .font(.body.weight(.semibold))
                    }
                } else {
                    Button(String(localized: String.LocalizationValue("users.detail.edit"))) {
                        viewModel.beginEditing()
                    }
                    .disabled(viewModel.snapshot == nil)
                }
            }
        }
        .task {
            viewModel.reload()
        }
    }

    private func detailScrollContent(snapshot: UserDetailSnapshot) -> some View {
        ScrollView {
            VStack(spacing: 16) {
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
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 16)
                }

                heroCard(snapshot: snapshot)

                identifiersCard(snapshot: snapshot)

                if viewModel.isEditing {
                    editingCard()
                }

                groupedCard(titleKey: "users.detail.section.contact") {
                    DetailRow(icon: "at", primary: snapshot.username.isEmpty ? "—" : "@\(snapshot.username)")
                    DetailRow(icon: "phone.fill", primary: snapshot.phone, url: DetailLinkBuilder.telURL(snapshot.phone))
                    DetailRow(icon: "envelope.fill", primary: snapshot.displayEmail, url: DetailLinkBuilder.mailURL(snapshot.displayEmail))
                    DetailLinkRow(title: snapshot.website)
                }

                groupedCard(titleKey: "users.detail.section.address") {
                    if snapshot.formattedAddressLines.isEmpty, snapshot.geoLine.isEmpty {
                        Text("—").foregroundColor(.secondary)
                    } else {
                        if !snapshot.formattedAddressLines.isEmpty {
                            Text(snapshot.formattedAddressLines).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        if !snapshot.geoLine.isEmpty {
                            Label(snapshot.geoLine, systemImage: "mappin.and.ellipse")
                                .foregroundColor(.secondary)
                                .padding(.top, snapshot.formattedAddressLines.isEmpty ? 0 : 6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }

                groupedCard(titleKey: "users.detail.section.company") {
                    if snapshot.companyName.isEmpty, snapshot.companyCatchPhrase.isEmpty, snapshot.companyBusinessSegment.isEmpty {
                        Text("—").foregroundColor(.secondary)
                    } else {
                        if !snapshot.companyName.isEmpty {
                            Text(snapshot.companyName).font(.headline)
                        }
                        if !snapshot.companyCatchPhrase.isEmpty {
                            Text(snapshot.companyCatchPhrase)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        if !snapshot.companyBusinessSegment.isEmpty {
                            Text(snapshot.companyBusinessSegment).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            .padding(.top, 8)
        }
    }

    private func heroCard(snapshot: UserDetailSnapshot) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 88))
                .foregroundColor(Color(UIColor.tertiaryLabel))

            if viewModel.isEditing {
                Text(String(localized: String.LocalizationValue("users.detail.editHeroHint")))
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text(snapshot.displayName)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(snapshot.username.isEmpty ? "—" : "@\(snapshot.username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if snapshot.displayName != snapshot.syncedName || snapshot.displayEmail != snapshot.syncedEmail {
                    Text(String(localized: String.LocalizationValue("users.detail.localOverrideBadge")))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(cardBackground())
        .padding(.horizontal, 16)
    }

    private func identifiersCard(snapshot: UserDetailSnapshot) -> some View {
        groupedCard(titleKey: "users.detail.section.identifiers") {
            LabeledMiniRow(titleKey: "users.detail.fields.localId", valueMonospaced: snapshot.localId)
            LabeledMiniRow(
                titleKey: "users.detail.fields.source",
                value: snapshot.isLocallyCreated
                    ? String(localized: String.LocalizationValue("users.detail.localOnly"))
                    : String(localized: String.LocalizationValue("users.detail.remoteBacked"))
            )
            LabeledMiniRow(
                titleKey: "users.detail.fields.apiId",
                value: snapshot.apiId == 0 ? "—" : "\(snapshot.apiId)"
            )
        }
    }

    private func editingCard() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: String.LocalizationValue("users.detail.editSection")))
                .font(.headline)

            TextField(String(localized: String.LocalizationValue("users.detail.field.namePlaceholder")), text: $viewModel.nameDraft)
                .textFieldStyle(.roundedBorder)

            TextField(String(localized: String.LocalizationValue("users.detail.field.emailPlaceholder")), text: $viewModel.emailDraft)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            Text(String(localized: String.LocalizationValue("users.detail.editHint")))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(cardBackground())
        .padding(.horizontal, 16)
    }

    private func groupedCard(titleKey: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: String.LocalizationValue(titleKey)))
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 10) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(cardBackground())
        }
        .padding(.horizontal, 16)
    }

    private func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Rows

private struct LabeledMiniRow: View {
    let titleKey: String
    private var valueLine: String?
    private var monospaceLine: String?

    init(titleKey: String, value: String) {
        self.titleKey = titleKey
        self.valueLine = value
        self.monospaceLine = nil
    }

    init(titleKey: String, valueMonospaced: String) {
        self.titleKey = titleKey
        self.valueLine = nil
        self.monospaceLine = valueMonospaced
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(String(localized: String.LocalizationValue(titleKey)))
                .font(.caption)
                .foregroundColor(.secondary)
            if let monospaceLine {
                Text(monospaceLine)
                    .font(.footnote.monospaced())
            } else if let valueLine {
                Text(valueLine)
                    .font(.body)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DetailRow: View {
    let icon: String
    let primary: String
    var url: URL?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 22, alignment: .center)
            if let url {
                Link(primary, destination: url)
                    .font(.body)
            } else {
                Text(primary)
                    .font(.body)
                    .foregroundColor(primary == "—" ? .secondary : .primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DetailLinkRow: View {
    let title: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "globe")
                .foregroundColor(.secondary)
                .frame(width: 22, alignment: .center)
            if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("—")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else if let url = DetailLinkBuilder.websiteURL(title) {
                Link(title, destination: url)
                    .font(.body)
                    .lineLimit(2)
            } else {
                Text(title).font(.body)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Links

private enum DetailLinkBuilder {
    static func telURL(_ raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let allowed = trimmed.filter { $0.isNumber || $0 == "+" }
        guard !allowed.isEmpty else { return nil }
        return URL(string: "tel:\(allowed)")
    }

    static func mailURL(_ raw: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = trimmed
        return c.url
    }

    static func websiteURL(_ raw: String) -> URL? {
        let w = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !w.isEmpty else { return nil }
        if w.hasPrefix("http://") || w.hasPrefix("https://") {
            return URL(string: w)
        }
        return URL(string: "https://\(w)")
    }
}
