//
//  AppDiagnostics.swift
//  userflow
//

import Foundation

/// Logs de errores orientados a consola Xcode / dispositivo. No sustituye contadores ni analítica.
enum AppDiagnostics {
    /// Fallo asociado a un **`Error`** (Realm, URLSession, Alamofire, errores Swift).
    static func recordHandledError(_ error: Error, context: String, file: StaticString = #file, line: UInt = #line) {
        log(file: file, line: line, severity: "error", context: context, detail: stringify(error))
    }

    /// Fallo de dominio ya manejado (validación, not found esperado).
    static func recordHandledFailure(_ message: String, context: String, file: StaticString = #file, line: UInt = #line) {
        log(file: file, line: line, severity: "failure", context: context, detail: message)
    }

    private static func stringify(_ error: Error) -> String {
        let ns = error as NSError
        let desc = String(describing: error)
        return "\(desc) | localized: \(error.localizedDescription) [\(ns.domain) \(ns.code)]"
    }

    private static func log(file: StaticString, line: UInt, severity: String, context: String, detail: String) {
        let basename = ("\(#file)" as NSString).lastPathComponent
        print("[userflow:\(severity)] \(basename):\(line) \(context) — \(detail)")
    }
}
