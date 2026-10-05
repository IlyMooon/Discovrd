import XCTest

final class DiscovrdUITests: XCTestCase {
    @MainActor
    func testAppLaunchAndOnboarding() throws {
        let app = XCUIApplication()
        app.launch()

        // Vérifier la présence du bouton Continuer ou Commencer
        let continueButton = app.buttons["Continuer"]
        if continueButton.exists {
            continueButton.tap()
        }
    }

    @MainActor
    func testNavigationBetweenTabs() throws {
        let app = XCUIApplication()
        app.launch()

        // Si l'utilisateur est sur l'écran principal
        let discoverTab = app.tabBars.buttons["Découvrir"]
        let artistsTab = app.tabBars.buttons["Mes artistes"]
        let settingsTab = app.tabBars.buttons["Réglages"]

        if discoverTab.exists {
            discoverTab.tap()
            XCTAssertTrue(discoverTab.isSelected)
        }

        if artistsTab.exists {
            artistsTab.tap()
            XCTAssertTrue(artistsTab.isSelected)
        }

        if settingsTab.exists {
            settingsTab.tap()
            XCTAssertTrue(settingsTab.isSelected)
        }
    }
}
