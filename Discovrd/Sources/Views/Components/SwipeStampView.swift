import SwiftUI

/// Tampon visuel en Liquid Glass indiquant l'intention (J'AIME ou PASSER) avec opacité graduelle lors du drag.
public struct SwipeStampView: View {
    public let direction: SwipeDirection
    public let progress: CGFloat // 0.0 à 1.0

    public init(direction: SwipeDirection, progress: CGFloat) {
        self.direction = direction
        self.progress = progress
    }

    public var body: some View {
        let isLike = direction == .like
        let text = isLike ? "J'AIME" : "PASSER"
        let color: Color = isLike ? .green : .red
        let iconName = isLike ? "heart.fill" : "xmark"

        HStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.headline.weight(.heavy))
            Text(text)
                .font(.headline.weight(.heavy))
                .tracking(2)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Color.clear
                .glassEffect(Glass.regular.tint(color.opacity(0.2)), in: .capsule)
        )
        .overlay(
            Capsule()
                .strokeBorder(color.opacity(0.8), lineWidth: 2)
        )
        .opacity(Double(min(1.0, max(0.0, progress * 1.5))))
        .rotationEffect(.degrees(isLike ? -12 : 12))
    }
}
