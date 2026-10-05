import SwiftUI

/// Vue d'onboarding interactive en 3 étapes présentant le fonctionnement de Discovrd.
public struct OnboardingView: View {
    public let onComplete: () -> Void

    @State private var currentPage: Int = 0

    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    private let steps: [(icon: String, title: String, description: String)] = [
        (
            icon: "sparkles.rectangle.stack",
            title: "Vos goûts, vos découvertes",
            description: "Discovrd analyse vos habitudes d'écoute Apple Music pour dénicher des perles rares faites pour vous."
        ),
        (
            icon: "hand.draw",
            title: "Swipez au rythme du son",
            description: "Glissez vers la droite pour ajouter à votre playlist Discovrd, ou vers la gauche pour passer. L'extrait audio se lance automatiquement."
        ),
        (
            icon: "person.2.crop.square.stack",
            title: "Explorez vos artistes",
            description: "Ne manquez aucune sortie de vos artistes favoris et découvrez leurs pépites encore absentes de votre bibliothèque."
        )
    ]

    public var body: some View {
        ZStack {
            // Fond ambiant
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.accentColor.opacity(0.35),
                    Color.purple.opacity(0.2),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 40,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                TabView(selection: $currentPage) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        VStack(spacing: 24) {
                            Image(systemName: steps[index].icon)
                                .font(.system(size: 72, weight: .light))
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 120, height: 120)
                                .background(
                                    Circle()
                                        .glassEffect(.regular, in: .circle)
                                )

                            Text(steps[index].title)
                                .font(.title.weight(.bold))
                                .multilineTextAlignment(.center)

                            Text(steps[index].description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 380)

                Spacer()

                // Bouton Suivant / Commencer
                Button(action: {
                    if currentPage < steps.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                }) {
                    Text(currentPage == steps.count - 1 ? "Commencer" : "Continuer")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.glassProminent)
                .padding(.horizontal, 32)
                .padding(.bottom, 36)
            }
        }
    }
}
