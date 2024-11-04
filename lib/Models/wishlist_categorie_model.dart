class WishlistCategorie {
  final int wishlistId;
  final int categoryId;

  WishlistCategorie({required this.wishlistId, required this.categoryId});

  // Convertir en Map pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    return {
      'idWishList': wishlistId,
      'idCategorie': categoryId,
    };
  }

  // Convertir un Map en WishlistCategorie
  factory WishlistCategorie.fromMap(Map<String, dynamic> map) {
    return WishlistCategorie(
      wishlistId: map['idWishList'],
      categoryId: map['idCategorie'],
    );
  }
}
