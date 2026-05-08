//
//  UserListCardRow.swift
//  userflow
//

import SwiftUI
import UIKit

/// Card content for the main user list (**`MT-07`** — grouped style, avatar por defecto tipo SF Symbol).
struct UserListCardRow: View {
    let item: UserListItem

    private var secondaryLine1: String {
        [item.username, item.city].filter { !$0.isEmpty }.joined(separator: " · ")
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: UIFontMetrics.default.scaledValue(for: 46)))
                .foregroundColor(Color(UIColor.tertiaryLabel))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(item.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)

                if !secondaryLine1.isEmpty {
                    Text(secondaryLine1)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                PhoneEmailRow(phone: item.phone, email: item.displayEmail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        [
            item.displayName,
            item.username,
            item.phone,
            item.displayEmail,
            item.city,
        ]
        .filter { !$0.isEmpty }
        .joined(separator: ", ")
    }
}

private struct PhoneEmailRow: View {
    let phone: String
    let email: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !phone.isEmpty {
                Label(phone, systemImage: "phone.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if !email.isEmpty {
                Label(email, systemImage: "envelope.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .labelStyle(.titleAndIcon)
    }
}
