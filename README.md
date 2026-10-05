# Discovrd 🎵

<p align="center">
  <strong>L'expérience de découverte musicale réinventée au rythme du swipe, connectée nativement à Apple Music.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2026%2B-blue?style=for-the-badge&logo=apple" alt="iOS 26+" />
  <img src="https://img.shields.io/badge/Swift-6.0%20Complete%20Concurrency-orange?style=for-the-badge&logo=swift" alt="Swift 6.0" />
  <img src="https://img.shields.io/badge/Framework-SwiftUI%20%7C%20MusicKit-purple?style=for-the-badge" alt="SwiftUI | MusicKit" />
  <img src="https://img.shields.io/badge/Storage-SwiftData-green?style=for-the-badge" alt="SwiftData" />
  <img src="https://img.shields.io/badge/Privacy-100%25%20On--Device-success?style=for-the-badge" alt="Privacy" />
</p>

---

## 📖 Présentation

**Discovrd** est une application iOS moderne combinant la gestuelle intuitive et addictive du **swipe de cartes** avec la richesse du catalogue **Apple Music**. 

Bâtie spécifiquement pour exploiter le design system **Liquid Glass** d'iOS 26, Discovrd analyse en local les habitudes d'écoute de l'utilisateur pour lui faire découvrir de nouvelles pépites méconnues et explorer les faces B inédites de ses artistes favoris, sans aucun serveur intermédiaire ni compromis sur la vie privée.

---

## ✨ Fonctionnalités Clés

### 🎴 SwipeDeck Interactif & Haptique
* **Gestuelle tactile naturelle** : glissez vers la droite (**J'aime**) pour enregistrer le titre dans la playlist automatique « Discovrd », ou vers la gauche (**Passer**) pour exclure le titre des recommandations.
* **Tampons interactifs réactifs** : affichage en verre teinté dynamique qui s'intensifie avec la translation et l'angle de rotation de la carte.
* **Bouton d'annulation (Undo)** : rattrapez un geste involontaire pendant 4 secondes grâce à une transition fluide par morphing (`glassEffectID`).

### 🔊 Audio Preview Instantané
* **Lecture à zéro latence** : lancement automatique de l'extrait officiel de 30 secondes dès l'apparition de la carte principale.
* **Préchargement intelligent** : mise en cache mémoire prédictive des flux audio des 2 cartes suivantes pour un enchaînement fluide et sans coupure.

### 🧠 Algorithme de Recommandation Sur-Mesure
* **Onglet Découvrir** : suggère des morceaux d'artistes absents de votre bibliothèque, ciblés selon vos artistes et genres les plus écoutés, accompagnés du contexte de recommandation (*« Parce que tu écoutes Daft Punk »*).
* **Onglet Mes Artistes** : file dédiée aux nouveautés récentes, sorties de singles et perles rares de vos artistes suivis non encore ajoutées à votre collection.
* **Moteur mathématique à décroissance temporelle** : pondération des écoutes avec décroissance exponentielle ($\lambda$) pour accorder la priorité aux coups de cœur récents tout en préservant l'éclectisme.
* **Règles de diversité strictes** : pas plus de 2 titres consécutifs du même artiste et filtrage des contenus explicites configurable.

### 🎨 Design System Liquid Glass (iOS 26)
* **Arrière-plan ambiant dynamique** : dégradé immersif réactif aux teintes dominantes de la pochette d'album (`MeshGradient`).
* **Contrôles en verre véritable** : boutons d'action intégrés dans un `GlassEffectContainer` (`buttonStyle(.glass)`).
* **Accessibilité de premier ordre** : support complet de Dynamic Type, VoiceOver, Réduction de mouvement et Contraste élevé.

### 🔒 100% Embarqué & Respect de la Vie Privée
* Calcul des profils d'écoute et stockage des interactions (swipes, historique, préférences) traités **exclusivement en local sur l'appareil** via **SwiftData**.
* Aucun serveur tiers, aucun tracker d'analyse, aucune collecte de données personnelles.

---

## 🏗 Architecture Technique

Le projet adopte une architecture **MVVM (Model-View-ViewModel)** réactive, couplée au modèle de concurrence stricte de **Swift 6**.

```
Discovrd/
├── Discovrd.xcodeproj/               # Configuration du projet Xcode
├── Discovrd/
│   ├── Sources/
│   │   ├── App/
│   │   │   └── DiscovrdApp.swift     # Cycle de vie @main, conteneur SwiftData & injection
│   │   ├── Models/
│   │   │   ├── TrackItem.swift       # Modèle unifié d'un morceau musical
│   │   │   ├── SwipeRecord.swift     # Modèle persistant SwiftData pour l'historique
│   │   │   ├── CachedTasteProfile.swift # Cache local du profil d'affinités
│   │   │   ├── TasteProfile.swift    # Moteur mathématique de score d'affinité
│   │   │   ├── DeckAlgorithm.swift   # Filtrage, déduplication et ordonnancement
│   │   │   └── AppSettings.swift     # Réglages utilisateur et état d'onboarding
│   │   ├── Services/
│   │   │   ├── ServiceProtocols.swift# Définition des protocoles & contrats
│   │   │   ├── AppleMusicService.swift# Intégration MusicKit & Music API
│   │   │   ├── TasteProfileService.swift# Agrégation et rafraîchissement des goûts
│   │   │   ├── AudioPreviewPlayer.swift # Lecteur AVQueuePlayer & préchargement
│   │   │   ├── SwiftDataSwipeStore.swift# Gestionnaire de persistance SwiftData
│   │   │   ├── MockMusicService.swift   # Données simulées pour tests & previews
│   │   │   └── MockSwipeStore.swift     # Store en mémoire pour tests isolés
│   │   └── Views/
│   │       ├── MainTabView.swift        # Navigation par onglets principale
│   │       ├── Components/              # Composants réutilisables (Deck, Glass, Cartes)
│   │       ├── Discover/                # Vue et ViewModel de l'onglet Découverte
│   │       ├── MyArtists/               # Vue et ViewModel de l'onglet Mes Artistes
│   │       ├── Onboarding/              # Écrans d'accueil et d'autorisation
│   │       └── Settings/                # Préférences et gestion des données
│   └── Resources/
│       ├── Assets.xcassets              # Couleurs sémantiques, icônes et visuels
│       ├── Info.plist                   # Configuration et permissions système
│       ├── PrivacyInfo.xcprivacy        # Manifeste officiel de confidentialité Apple
│       ├── fr.lproj/ & en.lproj/        # Localisation bilingue (Français / Anglais)
├── DiscovrdTests/                       # Tests unitaires et de logique pure
├── DiscovrdUITests/                     # Tests d'interface utilisateur
├── METADATA.md                          # Fiche produit & mots-clés App Store Connect
├── PRIVACY_POLICY.md                    # Politique de confidentialité prête à l'emploi
└── RELEASE_CHECKLIST.md                 # Checklist de signature, QA & publication
```

---

## 🚀 Démarrage Rapide

### Prérequis
* **macOS 15.0+**
* **Xcode 16.0+** avec SDK iOS 26+
* Un compte **Apple Music** actif (pour le streaming en conditions réelles et l'ajout à la playlist) ou utilisation du mode Mock intégré pour le développement hors-ligne.

### Installation

1. **Cloner le dépôt :**
   ```bash
   git clone https://github.com/votre-compte/Discovrd.git
   cd Discovrd
   ```

2. **Ouvrir le projet dans Xcode :**
   ```bash
   open Discovrd.xcodeproj
   ```

3. **Sélectionner la cible et le simulateur :**
   * Choisissez le scheme `Discovrd` et un simulateur (ex. *iPhone 16 Pro*).
   * Pressez `Cmd + R` pour compiler et exécuter l'application.

---

## 🧪 Tests Unitaires & Validation

Discovrd intègre une suite de tests unitaires couvrant les algorithmes critiques (`DeckAlgorithm`, `TasteProfile`, flux de swipe et persistance).

### Exécution via Xcode
Pressez `Cmd + U` dans Xcode pour lancer l'ensemble des suites `DiscovrdTests`.

### Exécution via le Terminal
```bash
xcodebuild test \
  -scheme Discovrd \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

---

## 📚 Documentation & Déploiement

* [**METADATA.md**](METADATA.md) : Descriptions commerciales complètes (FR / EN), mots-clés optimisés ASO et notes de guidage pour l'équipe Apple App Review.
* [**PRIVACY_POLICY.md**](PRIVACY_POLICY.md) : Politique de confidentialité transparente détaillant le traitement exclusivement on-device des données.
* [**RELEASE_CHECKLIST.md**](RELEASE_CHECKLIST.md) : Guide pas à pas pour la configuration des certificats de signature, provisioning profiles, TestFlight et soumission App Store.

---

## 📄 Licence

Ce projet est sous licence MIT. Consultez le fichier `LICENSE` pour plus de détails.
