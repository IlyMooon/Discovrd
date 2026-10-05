import SwiftUI

/// Barre d'actions flottante avec style Liquid Glass et GlassEffectContainer.
/// Le bouton Annuler apparaît et disparaît avec une transition de morphing (glassEffectID).
public struct ActionButtonsBar: View {
    public let canUndo: Bool
    public let onPass: () -> Void
    public let onUndo: () -> Void
    public let onLike: () -> Void

    @Namespace private var actionButtonsNamespace
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        canUndo: Bool,
        onPass: @escaping () -> Void,
        onUndo: @escaping () -> Void,
        onLike: @escaping () -> Void
    ) {
        self.canUndo = canUndo
        self.onPass = onPass
        self.onUndo = onUndo
        self.onLike = onLike
    }

    public var body: some View {
        GlassEffectContainer {
            HStack(spacing: 24) {
                // Bouton Passer (rouge doux teinté)
                Button(action: onPass) {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.red)
                        .frame(width: 58, height: 58)
                }
                .buttonStyle(.glass)
                .glassEffect(Glass.regular.tint(Color.red.opacity(0.15)).interactive(), in: .circle)
                .accessibilityLabel("Passer ce morceau")

                // Bouton Annuler (morphing dynamique avec glassEffectID)
                if canUndo {
                    Button(action: onUndo) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(Color.orange)
                            .frame(width: 48, height: 48)
                    }
                    .buttonStyle(.glass)
                    .glassEffect(Glass.regular.tint(Color.orange.opacity(0.15)).interactive(), in: .circle)
                    .glassEffectID("undo_button", in: actionButtonsNamespace)
                    .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                    .accessibilityLabel("Annuler le dernier swipe")
                }

                // Bouton J'aime (vert doux teinté / glassProminent)
                Button(action: onLike) {
                    Image(systemName: "heart.fill")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.green)
                        .frame(width: 58, height: 58)
                }
                .buttonStyle(.glassProminent)
                .glassEffect(Glass.regular.tint(Color.green.opacity(0.2)).interactive(), in: .circle)
                .accessibilityLabel("Aimer et ajouter à la playlist")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: canUndo)
    }
}
