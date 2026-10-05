# Guide de Déploiement & Release Checklist — Discovrd

Ce document détaille toutes les étapes manuelles réservées au propriétaire du compte Apple Developer pour signer, tester sur appareil physique et soumettre Discovrd sur l'App Store.

---

## Phase 1 : Configuration Apple Developer Portal

1. **Connexion au portail développeur** : Rendez-vous sur [developer.apple.com](https://developer.apple.com) avec votre compte payant (Apple Developer Program).
2. **Création / Configuration de l'App ID** :
   - Allez dans *Certificates, Identifiers & Profiles* > *Identifiers*.
   - Sélectionnez l'App ID de votre application ou créez-en un nouveau (ex: `com.germainbard.Discovrd` ou votre propre préfixe).
   - Dans la liste des **Capabilities**, cochez impérativement **MusicKit**.
   - Cliquez sur **Save** / **Continue**.
3. **Mise à jour du Bundle Identifier dans Xcode** :
   - Ouvrez `Discovrd.xcodeproj` dans Xcode.
   - Sélectionnez la cible `Discovrd` > onglet *Signing & Capabilities*.
   - Définissez votre **Team** de développement.
   - Remplacez le placeholder `com.example.Discovrd` par votre identifiant réel configuré sur le portail développeur.
   - Vérifiez que la capability **MusicKit** s'affiche bien cochée dans la liste des capabilities de la cible.

---

## Phase 2 : Icône d'application & Assets visuels

1. **Génération de l'icône (.icon / Icon Composer)** :
   - Conformément aux consignes Apple, l'icône ne doit pas contenir le logo officiel Apple Music ni évoquer une filiation officielle avec Apple.
   - L'Asset Catalog `Discovrd/Resources/Assets.xcassets/AppIcon.appiconset` est déjà préconfiguré avec un conteneur 1024x1024.
   - Placez votre fichier d'icône PNG 1024x1024 (fond opaque et éléments graphiques) ou importez votre composition de calques via Icon Composer Xcode 26.
2. **Captures d'écran pour l'App Store** :
   - Réalisez les captures d'écran requises pour iPhone 6.9" (iPhone 16 Pro Max / 17 Pro Max) et iPhone 6.3" / 6.7".
   - Capturez les vues clés :
     1. Écran de swipe « Découvrir » avec carte et fond ambiant réactif.
     2. Geste de swipe en action avec tampon « J'AIME ».
     3. Écran « Mes artistes ».
     4. Écran de Réglages Liquid Glass.

---

## Phase 3 : Tests sur Appareil Réel (Obligatoire avant soumission)

MusicKit et les requêtes catalogue authentifiées nécessitent un environnement matériel connecté :
1. Branchez votre iPhone via câble USB ou WiFi.
2. Dans Xcode, sélectionnez votre appareil physique comme cible d'exécution.
3. Lancez l'application en mode Debug ou TestFlight.
4. **Vérifications indispensables** :
   - Autorisez l'accès à Apple Music lors de la modale système.
   - Vérifiez que vos écoutes récentes et votre bibliothèque s'indexent correctement.
   - Testez la lecture d'extraits 30 secondes en haut-parleur et écouteurs.
   - Effectuez un swipe vers la droite (J'aime) : attendez 5 secondes et vérifiez dans l'application Musique native d'Apple qu'une nouvelle playlist nommée « Discovrd » a bien été créée avec le morceau ajouté.
   - Testez le bouton « Annuler » en effectuant un swipe et en touchant le bouton flèche orange dans les 4 secondes. Vérifiez que le morceau n'a pas été ajouté à la playlist Apple Music.

---

## Phase 4 : Hébergement de la Politique de Confidentialité

1. Prenez le contenu du fichier [`PRIVACY_POLICY.md`](file:///Users/germainbard/Documents/Discovrd/PRIVACY_POLICY.md).
2. Hébergez-le sur une URL publique accessible (ex: GitHub Pages de votre dépôt, Notion public, ou votre site personnel).
3. Conservez cette URL pour le champ « Privacy Policy URL » sur App Store Connect.

---

## Phase 5 : Création de la Fiche sur App Store Connect

1. Connectez-vous sur [appstoreconnect.apple.com](https://appstoreconnect.apple.com) > *Apps* > **+ (Nouvelle app)**.
2. Renseignez les champs en vous aidant du fichier [`METADATA.md`](file:///Users/germainbard/Documents/Discovrd/METADATA.md) :
   - **Nom** : Discovrd
   - **Sous-titre** : Découvrez au rythme du swipe
   - **Catégories** : Musique / Divertissement
   - **Description & Mots-clés** : Collez les textes fournis dans `METADATA.md`.
   - **Confidentialité de l'app** :
     - Indiquez « Nous ne collectons aucune donnée ».
     - Aucun suivi utilisateur (Tracking = Non).
   - **Notes pour l'équipe de validation (App Review)** :
     - Indiquez clairement que l'app utilise MusicKit et qu'un compte de test avec abonnement actif est requis.

---

## Phase 6 : Archivage & Téléversement

1. Dans Xcode, sélectionnez le menu *Product* > *Destination* > **Any iOS Device (arm64)**.
2. Cliquez sur *Product* > **Archive**.
3. Une fois l'archive générée dans l'organiseur, cliquez sur **Distribute App** > **App Store Connect** > **Upload**.
4. Patientez pendant le traitement binaire, puis activez la distribution TestFlight interne ou soumettez directement à la validation finale !
