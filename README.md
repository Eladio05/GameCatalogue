# GameCatalog

## Vue d'ensemble

**GameCatalog** permet aux utilisateurs de gérer leur collection de jeux vidéo, de suivre les jeux auxquels ils ont joué, et de tenir une liste de souhaits de jeux qu'ils désirent acquérir.

## Fonctionnalités

- **Gestion de la Collection de Jeux** : Ajoutez, modifiez et supprimez des jeux de votre collection avec des détails comme le titre, le statut, les heures jouées, les catégories et les plateformes.
- **Gestion de la Liste de Souhaits** : Maintenez une liste de jeux souhaités avec des détails comme la priorité, les catégories, les plateformes et des images personnalisées.

## Classes Importantes

### 1. **GameCollectionPage**
Affiche la collection de jeux de l'utilisateur sous forme de grille et permet la navigation vers les détails et la modification des jeux.

### 2. **GameCard**
Représente visuellement un jeu dans la collection avec des options pour modifier ou supprimer le jeu.

### 3. **AddGamePage**
Permet d'ajouter de nouveaux jeux à la collection avec des champs personnalisables.

### 4. **EditGamePage**
Permet de modifier les jeux existants avec des champs pré-remplis pour faciliter l'édition.

### 5. **WishlistPage**
Affiche la liste de souhaits des jeux.

### 6. **WishlistCard**
Représente un jeu dans la liste de souhaits avec des options pour modifier ou supprimer.

### 7. **AddWishlistPage** & **EditWishlistPage**
Permettent d'ajouter ou de modifier des jeux dans la liste de souhaits.

### 8. **GameDetailsPage** & **WishlistDetailsPage**
Affichent des informations détaillées sur un jeu ou une entrée de la liste de souhaits.

### 9. **BottomNavPage**
Gère la navigation entre les pages et l'ajout de nouveaux jeux ou souhaits.

## Choix de Design

- **Interface Inspirée du Gaming** : Thème sombre avec des accents rouges et violets pour une esthétique gaming immersive.
- **Personnalisation Totale** : Création et gestion des catégories et plateformes adaptées à chaque utilisateur.

## Structure de la Base de Données

### Utilisation de SQLite
L'application utilise SQLite pour stocker les données localement, avec les tables suivantes :
- **Game** pour la gestion de la collection.
- **Catégories** pour organiser les jeux par genres.
- **Plateformes** pour gérer les supports.
- **Table associative entre Catégorie - Jeux, Plateforme - Jeu** pour relier plusieurs catégories et plateformes à un même jeu. Même chose pour la wishlist.
- **WishList** pour suivre les jeux que l'utilisateur souhaite.

## Modèles et Providers

### Modèles
- **GameModel** : Représente les informations d'un jeu, telles que le titre, le statut, les heures jouées, la date d'ajout et le chemin d'image.
- **CategorieModel** : Définit les catégories disponibles pour classer les jeux (ex : RPG, Plateforme, etc.).
- **PlateformeModel** : Définit les plateformes sur lesquelles les jeux sont disponibles (ex : PC, Console, etc.).
- **WishListModel** : Représente un jeu souhaité avec des attributs comme la priorité, les catégories et les plateformes.
- **GameCategorieModel** : Relie un jeu à une ou plusieurs catégories.
- **GamePlateformeModel** : Relie un jeu à une ou plusieurs plateformes.
- **WishListCategorieModel** : Relie un élément de la wishlist à une ou plusieurs catégories.
- **WishListPlateformeModel** : Relie un élément de la wishlist à une ou plusieurs plateformes.

### Providers
Chaque table dispose d'un **provider** dédié pour effectuer les opérations CRUD :
- **GameProvider** : Gère l'ajout, la mise à jour, la suppression et la récupération des jeux de la base de données.
- **CategorieProvider** : Gère les opérations liées aux catégories.
- **PlateformeProvider** : S'occupe des interactions avec les plateformes.
- **GameCategorieProvider** et **GamePlateformeProvider** : Fournissent la gestion des relations entre les jeux et leurs catégories/plateformes respectives.
- **WishListProvider** : Gère la gestion des éléments de la liste de souhaits.
- **WishlistCategorieProvider** et **WishlistPlateformeProvider** : Fournissent la gestion des relations entre les jeux de la wishlist et leurs catégories/plateformes respectives.
