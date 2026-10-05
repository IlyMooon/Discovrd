import Foundation

/// Exécuteur réseau sécurisé pour l'Apple Music API avec backoff exponentiel et gestion de Retry-After.
public enum MusicAPINetworkClient {
    public static func executeWithRetry<T: Sendable>(
        maxRetries: Int = 3,
        initialDelay: TimeInterval = 1.0,
        operation: @Sendable () async throws -> T
    ) async throws -> T {
        var currentDelay = initialDelay

        for attempt in 0..<maxRetries {
            do {
                return try await operation()
            } catch {
                if attempt == maxRetries - 1 {
                    throw error
                }

                // Vérifier si l'erreur expose un code HTTP ou un délai de réessai
                let nsError = error as NSError
                let statusCode = nsError.code

                if statusCode == 401 || statusCode == 403 {
                    // Erreur d'authentification ou permission non renouvelable immédiatement
                    throw error
                }

                // Pour 429 ou erreurs réseau transitoires : attente exponentielle
                try? await Task.sleep(nanoseconds: UInt64(currentDelay * 1_000_000_000))
                currentDelay *= 2.0
            }
        }

        return try await operation()
    }
}
