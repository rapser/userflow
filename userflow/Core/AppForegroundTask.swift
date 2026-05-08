//
//  AppForegroundTask.swift
//  userflow
//

import Foundation

/// `Task { }` en vistas: captura errores Swift que lleguen hasta el task (antes de llegar al runtime como terminate).
enum AppForegroundTask {
    /// Trabajo **await** dentro de `.task`, `.refreshable`, etc.
    @MainActor
    static func executeSafe(_ context: String, operation: @MainActor () async throws -> Void) async {
        do {
            try await operation()
        } catch {
            AppDiagnostics.recordHandledError(error, context: context)
        }
    }

    /// Variante cuando el trabajo no declara `throws`.
    @MainActor
    static func executeSafe(_ context: String, operation: @MainActor () async -> Void) async {
        await operation()
    }

    /// Encola trabajo sin await en el sitio del llamante (`onChange`, `NavigationLink`).
    @MainActor
    static func scheduleSafe(_ context: String, operation: @escaping @MainActor () async throws -> Void) {
        Task { @MainActor in
            await executeSafe(context, operation: operation)
        }
    }

    @MainActor
    static func scheduleSafe(_ context: String, operation: @escaping @MainActor () async -> Void) {
        Task { @MainActor in
            await executeSafe(context, operation: operation)
        }
    }
}
