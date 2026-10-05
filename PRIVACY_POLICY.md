# Politique de Confidentialité — Discovrd (Privacy Policy)

**Dernière mise à jour : 5 octobre 2026**

La confidentialité de vos données personnelles est au cœur de l'architecture de **Discovrd**. Cette politique explique comment l'application traite vos informations.

---

## 1. Principe Fondamental : Tout reste sur votre appareil

Discovrd ne possède **aucun serveur externe**, **aucune base de données distante** et n'intègre **aucun service d'analyse tiers ni régie publicitaire**. 

Toutes les opérations d'analyse de goûts, de calcul de scores et de gestion de l'historique de vos swipes s'exécutent exclusivement en local sur votre appareil iOS grâce aux technologies Apple SwiftData et UserDefaults.

---

## 2. Données Apple Music et Bibliothèque

Avec votre accord explicite via l'autorisation système iOS (`MusicAuthorization`) :
- **Historique d'écoute & Bibliothèque** : Discovrd interroge localement votre historique récent et le contenu de votre bibliothèque pour dégager vos artistes et genres préférés. Ces données ne sont jamais téléversées ni partagées.
- **Ajout à vos playlists** : Lorsque vous aimez un morceau (swipe vers la droite), Discovrd utilise l'API système MusicKit pour ajouter ce titre à votre playlist « Discovrd » (et optionnellement à votre bibliothèque selon vos réglages).
- **Identifiant de Storefront** : L'application récupère l'identifiant du pays de votre boutique Apple Music (ex: « fr ») uniquement pour adresser des requêtes valides au catalogue musical d'Apple.

---

## 3. Données de Télémétrie et Traqueurs

- **Aucun traqueur (Zero Tracking)** : Discovrd respecte scrupuleusement les exigences App Tracking Transparency d'Apple. L'application ne vous suit sur aucun autre service, site web ou application.
- **Privacy Manifest (`PrivacyInfo.xcprivacy`)** : Notre fichier de confidentialité système déclare formellement `NSPrivacyTracking = false` et l'absence totale de collecte de données de contact, localisation, identifiants ou contenu utilisateur.

---

## 4. Vos Choix et Suppression des Données

Vous conservez à tout instant le contrôle total de vos données :
- **Réinitialisation** : Rendez-vous dans l'onglet « Réglages » de l'application et touchez **« Réinitialiser l'historique de swipes »** pour purger instantanément l'ensemble des titres passés et aimés en mémoire locale.
- **Révocation de l'accès Apple Music** : Vous pouvez révoquer l'autorisation à tout moment dans l'application *Réglages* d'iOS > *Confidentialité et sécurité* > *Média et Apple Music*.
- **Désinstallation** : La suppression de l'application entraîne l'effacement immédiat et irréversible de l'ensemble des données stockées dans le conteneur SwiftData de l'application.

---

## 5. Contact

Pour toute question relative à cette politique de confidentialité :
- Développeur : Germain Bard
- Projet : Discovrd iOS
